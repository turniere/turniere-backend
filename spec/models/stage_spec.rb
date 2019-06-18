# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe 'association' do
    it { should belong_to :tournament }
    it { should have_many :matches }
    it { should have_many :groups }
  end

  describe '#teams' do
    context 'group stage' do
      before do
        @stage = create(:group_stage, group_count: 1) # this is getting stubbed anyways
        @teams = create_list(:team, 4)
        expect_any_instance_of(Group)
          .to receive(:teams)
          .and_return(@teams)
      end

      it 'returns all teams from the matches within the groups below' do
        teams = @stage.teams
        expect(teams).to match_array(@teams)
      end
    end

    context 'playoff stage' do
      before do
        @stage = create(:playoff_stage, match_count: 1) # this is getting stubbed anyways
        @teams = create_list(:team, 4)
        expect_any_instance_of(Match)
          .to receive(:teams)
          .and_return(@teams)
      end

      it 'returns all teams from the matches within the matches below' do
        teams = @stage.teams
        expect(teams).to match_array(@teams)
      end
    end

    context 'empty stage' do
      it 'returns an empty Array' do
        expect(create(:stage).teams).to match_array([])
      end
    end
  end

  describe '#over?' do
    context 'group stage' do
      context 'with unfinished matches' do
        it 'returns false' do
          expect(create(:group_stage).over?).to eq(false)
        end
      end

      context 'with all matches finished' do
        let(:finished_group_stage) do
          group_stage = create(:group_stage)
          group_stage.groups.map(&:matches).flatten.each do |m|
            m.state = :finished
            m.save!
          end
          group_stage
        end

        it 'returns true' do
          expect(finished_group_stage.over?).to eq(true)
        end
      end
    end

    context 'playoff stage' do
      context 'with unfinished matches' do
        it 'returns false' do
          expect(create(:playoff_stage).over?).to eq(false)
        end
      end

      context 'with all matches finished' do
        let(:finished_playoff_stage) do
          playoff_stage = create(:playoff_stage)
          playoff_stage.matches.each do |m|
            m.state = :finished
            m.save!
          end
          playoff_stage
        end

        it 'returns true' do
          expect(finished_playoff_stage.over?).to eq(true)
        end
      end
    end

    context 'empty stage' do
      it 'returns false' do
        expect(create(:stage).over?).to eq(false)
      end
    end
  end
end
