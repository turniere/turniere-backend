# frozen_string_literal: true

RSpec.describe GroupStageService do
  before do
    @stage = create(:stage)
    @teams1 = create_list(:team, 4)
    @teams2 = create_list(:team, 4)
    @groups = Hash[1 => @teams1, 2 => @teams2].values
  end
  describe '#generate_group_stage method' do
    it 'returns a stage object' do
      group_stage = GroupStageService.generate_group_stage(@groups)
      expect(group_stage).to be_a(Stage)
    end

    it 'returns a stage object with level -1' do
      group_stage_level = GroupStageService.generate_group_stage(@groups).level
      expect(group_stage_level).to be(-1)
    end

    it 'adds the provided groups to the stage' do
      group_stage_teams = GroupStageService.generate_group_stage(@groups).teams
      expect(group_stage_teams).to match_array(@groups.flatten)
    end

    it 'adds GroupScore objects for every team present in the group' do
      group_stage = GroupStageService.generate_group_stage(@groups)
      teams_in_group_scores = group_stage.groups.map{ |g| g.group_scores.map(&:team) }.flatten
      expect(teams_in_group_scores).to match_array(@groups.flatten)
    end

    it 'raises exception when given different sizes of groups' do
      unequal_groups = @groups
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
end
