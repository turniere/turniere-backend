# frozen_string_literal: true

RSpec.describe GroupStageService do
  before do
    @teams1 = create_list(:team, 4)
    @teams2 = create_list(:team, 4)
    @prepared_groups = Hash[1 => @teams1, 2 => @teams2].values
  end
  describe '#generate_group_stage method' do
    it 'returns a stage object' do
      group_stage = GroupStageService.generate_group_stage(@prepared_groups)
      expect(group_stage).to be_a(Stage)
    end

    it 'returns a stage object with level -1' do
      group_stage_level = GroupStageService.generate_group_stage(@prepared_groups).level
      expect(group_stage_level).to be(-1)
    end

    it 'adds the provided groups to the stage' do
      group_stage_teams = GroupStageService.generate_group_stage(@prepared_groups).teams
      expect(group_stage_teams).to match_array(@prepared_groups.flatten)
    end

    it 'adds GroupScore objects for every team present in the group' do
      group_stage = GroupStageService.generate_group_stage(@prepared_groups)
      teams_in_group_scores = group_stage.prepared_groups.map { |g| g.group_scores.map(&:team) }.flatten
      expect(teams_in_group_scores).to match_array(@prepared_groups.flatten)
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

      it 'assigns 1 point to every team' do
        @changed_group_scores.map(&:group_points).each do |points|
          expect(points).to be(1)
        end
      end

      it_should_behave_like 'only_return_group_scores'

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
end
