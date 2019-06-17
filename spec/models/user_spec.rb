# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { should have_many :tournaments }
    it { should have_many :bets }
  end

  describe 'validation' do
    subject { create(:user) }
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of(:username).case_insensitive }
  end
end
