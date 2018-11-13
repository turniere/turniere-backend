# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tournament, type: :model do
  before do
    @tournament = create(:tournament)
  end

  describe 'validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of :code }
    it { should_not validate_presence_of :description }
    it { should_not validate_presence_of :public }
  end

  describe 'initialization' do
    it 'should have a code' do
      assert_equal @tournament.code.length, 6
    end
    it 'should be public' do
      assert_equal @tournament.public, true
    end
  end

  describe 'association' do
    it { should belong_to :user }
    it { should have_many :teams }
    it { should have_many :stages }
  end
end
