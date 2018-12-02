# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tournament, type: :model do
  before do
    @tournament = create(:tournament)
  end

  describe 'validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it do
      tournament = create(:tournament, code: Faker::Dog.name)
      expect(tournament).to validate_uniqueness_of :code
    end
    it { should_not validate_presence_of :description }
    it { should_not validate_presence_of :public }
  end

  describe 'initialization' do
    it 'should have a code' do
      expect(@tournament.code.length).to be(6)
    end
    it 'should be public' do
      expect(@tournament.public).to be(true)
    end
  end

  describe 'association' do
    it { should belong_to :user }
    it { should have_many :teams }
    it { should have_many :stages }
  end

  it 'has valid factory' do
    expect(build(:tournament)).to be_valid
  end
end
