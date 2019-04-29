# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe 'association' do
    it { should belong_to :tournament }
    it { should have_many :matches }
    it { should have_many :groups }
  end

  it 'has a valid factory' do
    expect(build(:stage)).to be_valid
    expect(build(:group_stage)).to be_valid
  end

  describe '#teams' do
    context 'group stage' do
      before do
        @stage = create(:group_stage, group_count: 1) # this is getting stubbed anyways
        @teams = create_list(:team, 4)
        expect_any_instance_of(Group)
          .to receive(:teams)
          .and_return(@teams)
      end

      it 'returns all teams from the matches within the groups below' do
        teams = @stage.teams
        expect(teams).to match_array(@teams)
      end
    end

    context 'playoff stage' do
      before do
        @stage = create(:playoff_stage, match_count: 1) # this is getting stubbed anyways
        @teams = create_list(:team, 4)
        expect_any_instance_of(Match)
          .to receive(:teams)
          .and_return(@teams)
      end

      it 'returns all teams from the matches within the matches below' do
        teams = @stage.teams
        expect(teams).to match_array(@teams)
      end
    end
  end
end
