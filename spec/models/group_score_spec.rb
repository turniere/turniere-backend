# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupScore, type: :model do
  describe 'association' do
    it { should belong_to :team }
    it { should belong_to :group }
  end

  it 'has a valid factory' do
    expect(build(:group_score)).to be_valid
  end
end
