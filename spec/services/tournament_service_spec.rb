# frozen_string_literal: true

RSpec.describe TournamentService do
  describe '#calculate_default_amount_of_teams_advancing' do
    before do
      @instant_finalists_amount, @intermediate_round_participants_amount =
        TournamentService.calculate_default_amount_of_teams_advancing(32, 5)
    end

    it 'accurately calculates @instant_finalists_amount' do
      expect(@instant_finalists_amount).to eq(30)
    end

    it 'accurately calculates @intermediate_round_participants_amount' do
      expect(@intermediate_round_participants_amount).to eq(4)
    end
  end
end
