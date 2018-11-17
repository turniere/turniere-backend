# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score, type: :model do
  describe 'validation' do
    it { should validate_presence_of :score }
  end

  describe 'association' do
    it { should belong_to :match }
    it { should belong_to :team }
  end

  it 'has a valid factory' do
    expect(build(:score)).to be_valid
  end
end
