# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchScore, type: :model do
  describe 'association' do
    it { should belong_to :match }
    it { should belong_to :team }
  end

  describe '#part_of_group_match?' do
    it 'is part of a group match' do
      expect(create(:running_group_match).match_scores.first.part_of_group_match?).to be(true)
    end

    it 'isn\'t part of a group match' do
      expect(create(:running_playoff_match).match_scores.first.part_of_group_match?).to be(false)
    end
  end
end
