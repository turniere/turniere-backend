# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  context 'association' do
    it { should have_many :match_scores }
    it { should belong_to(:stage).optional }
    it { should belong_to(:group).optional }
  end

  context '#new' do
    it 'needs only a group' do
      match = Match.new group: build(:group)
      expect(match).to be_valid
    end

    it 'needs only a stage' do
      match = Match.new stage: build(:stage)
      expect(match).to be_valid
    end

    it 'can\'t have a group and a stage' do
      match = Match.new group: build(:group), stage: build(:stage)
      expect(match).to be_invalid
    end
  end

  context 'match_scores' do
    before do
      @match = create(:match)
      @match.match_scores << build_pair(:match_score)
    end

    it 'can only have two match_scores' do
      @match.match_scores << build(:match_score)
      expect(@match).to be_invalid
    end

    it 'can access its match_scores' do
      @match.match_scores[0].points = 0
      @match.match_scores[1].points = 0
    end
  end

  context '#winner' do
    before do
      @undecided_match = create(:undecided_group_match)
      @decided_match = create(:decided_playoff_match)
    end

    it 'returns a winner Team for a decided match' do
      winner = @decided_match.winner
      expect(winner).to be_a Team
    end

    it 'returns nil for an undecided match' do
      winner = @undecided_match.winner
      expect(winner).to be(nil)
    end
  end

  context '#teams' do
    before do
      @playoff_match = create(:running_playoff_match)
      @group_match = create(:running_group_match)
      @teams = create_list(:team, 2)
      @match_scores = create_list(:match_score, 2)
      @match_scores.each_with_index { |match, i| match.team = @teams[i] }
      @playoff_match.match_scores = @match_scores
      @group_match.match_scores = @match_scores
    end

    context 'called on group match' do
      let(:call_teams_on_group_match) do
        @group_match.teams
      end

      it 'returns 2 team objects' do
        teams = call_teams_on_group_match
        expect(teams).to match_array(@teams)
      end
    end

    context 'called on playoff match' do
      let(:call_teams_on_playoff_match) do
        @playoff_match.teams
      end

      it 'returns 2 team objects' do
        teams = call_teams_on_playoff_match
        expect(teams).to match_array(@teams)
      end
    end
  end

  it 'has a valid factory' do
    expect(build(:match)).to be_valid
    expect(build(:running_playoff_match)).to be_valid
    expect(build(:group_match)).to be_valid
  end
end
