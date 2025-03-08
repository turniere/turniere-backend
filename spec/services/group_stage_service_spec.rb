# frozen_string_literal: true

RSpec.describe GroupStageService do
  before do
    @teams1 = create_list(:team, 4)
    @teams2 = create_list(:team, 4)
    @prepared_groups = Hash[1 => @teams1, 2 => @teams2].values
  end
  describe '#generate_group_stage' do
    let(:prepared_groups_groupstage) do
      GroupStageService.generate_group_stage(@prepared_groups)
    end

    it 'returns a stage object' do
      expect(prepared_groups_groupstage).to be_a(Stage)
    end

    it 'assigns the correct state' do
      expect(prepared_groups_groupstage.state).to eq('in_progress')
    end

    it 'assigns unique numbers to each group' do
      groups = prepared_groups_groupstage.groups
      groups.sort_by(&:number).each_with_index do |group, i|
        expect(group.number).to eq(i + 1)
      end
    end

    it 'returns a stage object with level -1' do
      expect(prepared_groups_groupstage.level).to be(-1)
    end

    it 'adds the provided groups to the stage' do
      expect(prepared_groups_groupstage.teams).to match_array(@prepared_groups.flatten)
    end

    it 'adds GroupScore objects for every team present in the group' do
      expect(prepared_groups_groupstage.groups.map { |g| g.group_scores.map(&:team) }.flatten)
        .to match_array(@prepared_groups.flatten)
    end

    it 'raises exception when given different sizes of groups' do
      unequal_groups = @prepared_groups
      unequal_groups.first.pop
      expect { GroupStageService.generate_group_stage(unequal_groups) }
        .to raise_exception 'Groups need to be equal size'
    end

    it 'raises exception when given no groups' do
      expect { GroupStageService.generate_group_stage([]) }
        .to raise_exception 'Cannot generate group stage without groups'
    end
  end

  describe '#get_group_object_from' do
    it 'returns a group' do
      group = GroupStageService.get_group_object_from(@teams1)
      expect(group).to be_a(Group)
    end
  end

  describe '#generate_all_matches_between' do
    it 'generates a list of not started matches' do
      matches = GroupStageService.generate_all_matches_between(@teams2)
      matches.each do |match|
        expect(match).to be_a(Match)
        match_state = match.state
        expect(match_state).to eq('not_started')
      end
    end

    it 'generates the right amount of matches' do
      matches = GroupStageService.generate_all_matches_between(@teams2)
      # (1..@teams2.size-1).sum -> 1. Team has to play against n-1 teams; second against n-2 ....
      expect(matches.size).to be((1..@teams2.size - 1).sum)
    end

    it 'gives matches exclusive positions' do
      matches = GroupStageService.generate_all_matches_between(@teams2)
      match_positions = matches.map(&:position)
      expect(match_positions.length).to eq(match_positions.uniq.length)
    end

    it 'doesn\'t match a team against itself' do
      matches = GroupStageService.generate_all_matches_between(@teams1)
      matches.each do |match|
        expect(match.teams.first).to_not eq(match.teams.second)
      end
    end
  end

  describe '#update_group_scores' do
    shared_examples_for 'only_return_group_scores' do
      it 'only returns group_scores' do
        @changed_group_scores.each do |gs|
          expect(gs).to be_a(GroupScore)
        end
      end
    end

    context 'with only undecided matches' do
      before do
        @group = create(:group, match_factory: :running_group_match)
        @group.matches.each do |match|
          match.match_scores.each do |ms|
            ms.points = 42
            ms.save!
          end
        end
        @changed_group_scores = GroupStageService.update_group_scores(@group)
      end

      it 'assigns one point to every team' do
        @changed_group_scores.map(&:group_points).each do |points|
          expect(points).to be(1)
        end
      end

      it 'returns correct values for received_points' do
        @changed_group_scores.map(&:received_points).each do |points|
          expect(points).to be(42)
        end
      end

      it 'returns correct values for scored_points' do
        @changed_group_scores.map(&:scored_points).each do |points|
          expect(points).to be(42)
        end
      end

      it_should_behave_like 'only_return_group_scores'
    end

    context 'with only decided matches' do
      before do
        @group = create(:group, match_factory: :running_group_match)
        @group.matches.each_with_index do |match, i|
          match.match_scores.each_with_index do |ms, j|
            match_score_number = i + j
            ms.points = match_score_number
            ms.save!
          end
        end
        @changed_group_scores = GroupStageService.update_group_scores(@group)
      end

      it 'assigns the right amount of points' do
        winning_teams = @changed_group_scores.select { |gs| gs.group_points == 3 }
        losing_teams = @changed_group_scores.select { |gs| gs.group_points == 0 }
        # Assure that half of the teams won and got 3 points
        expect(winning_teams.size).to be(@changed_group_scores.size / 2)
        # and half of them lost and got 0
        expect(losing_teams.size).to be(@changed_group_scores.size / 2)
      end

      it_should_behave_like 'only_return_group_scores'
    end
  end

  describe '#teams_sorted_by_group_scores' do
    before do
      @group_to_sort = create(:group, match_count: 10, match_factory: :filled_group_match)
    end

    let(:sorted_teams) do
      GroupStageService.teams_sorted_by_group_scores(@group_to_sort)
    end

    let(:sorted_teams_grouped_by_group_points) do
      sorted_teams.group_by { |t| @group_to_sort.group_scores.find_by(team: t).group_points }.values
    end

    it 'sorts the teams after group_scores first' do
      i = 0
      while i < (sorted_teams.size - 1)
        expect(@group_to_sort.group_scores.find_by(team: sorted_teams[i]).group_points)
          .to be >= @group_to_sort.group_scores.find_by(team: sorted_teams[i + 1]).group_points
        i += 1
      end
    end

    it 'sorts the teams after difference_in_points second' do
      sorted_teams_grouped_by_group_points.each do |teams|
        i = 0
        while i < (teams.size - 1)
          expect(@group_to_sort.group_scores.find_by(team: teams[i]).difference_in_points)
            .to be >= @group_to_sort.group_scores.find_by(team: teams[i + 1]).difference_in_points
          i += 1
        end
      end
    end
  end

  describe '#get_advancing_teams', focus: true do
    context 'when special case for po2 applies' do
      before do
        # Create some example teams
        teams1 = [Team.new(name: 'Team 1'), Team.new(name: 'Team 2'), Team.new(name: 'Team 3'), Team.new(name: 'Team 4')]
        teams2 = [Team.new(name: 'Team 5'), Team.new(name: 'Team 6'), Team.new(name: 'Team 7'), Team.new(name: 'Team 8')]

        # Group the teams
        groups = [teams1, teams2]

        # Generate the group stage
        @group_stage = GroupStageService.generate_group_stage(groups)

        @tournament = create(:prepared_group_stage_tournament, group_stage: @group_stage)

        # iterate over all groups and update the matches within to all be decided
        @group_stage.groups.each do |group|
          group.matches.each do |match|
            match.match_scores.each do |ms|
              # give the team the amount of points as in their name
              ms.points = ms.team.name.split(' ').last.to_i
              ms.save!
            end
            match.state = 'finished'
            match.save!
          end
          gs = GroupStageService.update_group_scores(group)
          gs.each(&:save!)
        end
      end
    end
  end
end
