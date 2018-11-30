# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchScore, type: :model do
  describe 'association' do
    it { should belong_to :match }
    it { should belong_to :team }
  end

  it 'has a valid factory' do
    expect(build(:match_score)).to be_valid
  end
end
