# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  context 'association' do
    it { should have_many :scores }
    it { should belong_to :stage }
    it { should belong_to :group }
  end

  context 'scores' do
    before do
      @match = create(:match)
      @match.scores << build_pair(:score)
    end

    it 'can only have two scores' do
      @match.scores << build(:score)
      expect(@match).to be_invalid
    end

    it 'can access its scores' do
      @match.scores[0].score = 0
      @match.scores[1].score = 0
    end
  end

  it 'has a valid factory' do
    expect(build(:match)).to be_valid
  end
end
