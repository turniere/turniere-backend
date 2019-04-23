# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { should have_many :tournaments }
  end

  describe 'validation' do
    subject { create(:user) }
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).case_insensitive }
  end

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end
end
