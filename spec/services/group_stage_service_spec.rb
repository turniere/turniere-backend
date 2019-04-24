# frozen_string_literal: true

RSpec.describe GroupStageService do
  before do
    @stage = create(:stage)
    @groups = create_list(:group, 4)
    @groups_list = [ %w(one two three), %w(a b c)] # @groups.map{ |group| [group.teams.map{|group| group.name}]}
  end
  describe 'generate_group_stage method' do
    it 'returns a stage object' do
      group_stage = GroupStageService.generate_group_stage(@groups)
      expect(group_stage).to be_a(Stage)
    end

    it 'returns false when given different sizes of groups' do
      unequal_groups = @groups_list
      unequal_groups.first.pop
      group_stage = GroupStageService.generate_group_stage(@groups_list)
    end
  end

  describe 'get_group_object_from' do
    groups = [%w(one two three), %w(four five six)]

  end

  describe 'generate_all_matches_between' do

  end
end
