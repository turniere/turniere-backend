# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe 'validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it do
      tournament = create(:tournament, code: Faker::Creature::Dog.name)
      expect(tournament).to validate_uniqueness_of :code
    end
    it { should_not validate_presence_of :description }
    it { should_not validate_presence_of :public }
  end

  describe 'initialization' do
    subject { create(:tournament) }

    it 'should have a code' do
      expect(subject.code.length).to be(6)
    end
    it 'should be public' do
      expect(subject.public).to be(true)
    end
  end

  describe 'association' do
    it { should belong_to :user }
    it { should have_many :teams }
    it { should have_many :stages }
  end

  describe '#matches' do
    context 'group stage tournament' do
      before do
        @tournament = create(:group_stage_tournament)
      end

      it 'returns only matches' do
        @tournament.matches.each do |m|
          expect(m).to be_a Match
        end
      end
    end

    context 'stage tournament' do
      before do
        @tournament = create(:stage_tournament)
      end

      it 'returns only matches' do
        @tournament.matches.each do |m|
          expect(m).to be_a Match
        end
      end
    end
  end

  describe 'Factory', focus: true do
    it 'creates a valid tournament' do
      tournament = create(:tournament)
      expect(tournament).to be_valid
    end

    it 'creates a valid stage tournament' do
      tournament = create(:stage_tournament)
      expect(tournament).to be_valid
    end

    it 'creates a valid group stage tournament' do
      tournament = create(:group_stage_tournament)
      expect(tournament).to be_valid
    end
    describe 'bpwstr tournament' do
      it 'creates a valid bpwstr tournament' do
        tournament = create(:bpwstr_tournament)
        expect(tournament).to be_valid
      end

      it 'has the correct teams assigned to it' do
        tournament = create(:bpwstr_tournament)
        expect(tournament.teams.count).to eq(32)
        # also check that the teams in the matches are the same
        expect(tournament.teams).to match_array(tournament.matches.map(&:teams).flatten)
      end
    end
  end
end
