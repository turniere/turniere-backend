# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'association' do
    it { should belong_to :stage }
    it { should have_many :matches }
    it { should have_many :group_scores }
  end

  describe '#teams' do
    before do
      @group = create(:group, match_count: 1) # this is getting stubbed anyways
      @teams = create_list(:team, 4)
      expect_any_instance_of(Match)
        .to receive(:teams)
        .and_return(@teams)
    end

    it 'returns all teams from the matches within the matches below' do
      teams = @group.teams
      expect(teams).to match_array(@teams)
    end
  end

  # spec/models/group_spec.rb
  require 'rails_helper'

  describe 'Factory' do
    it 'creates a valid group' do
      group = create(:group)
      expect(group).to be_valid
    end

    it 'creates the correct number of matches' do
      group = create(:group, match_count: 3)
      expect(group.matches.count).to eq(3)
    end

    it 'creates group scores for each team' do
      group = create(:group)
      expect(group.group_scores.count).to eq(group.teams.count)
    end
  end
end
