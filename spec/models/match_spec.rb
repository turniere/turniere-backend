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

  it 'has a valid factory' do
    expect(build(:match)).to be_valid
    expect(build(:running_playoff_match)).to be_valid
    expect(build(:group_match)).to be_valid
  end
end
