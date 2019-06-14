# frozen_string_literal: true

RSpec.describe UserService do
  before do
    @user = create(:user)
    @service = UserService.new @user
    @team = create(:team)
  end

  describe '#bet!' do
    context 'with an unrelated team' do
      it 'throws an exception' do
        expect do
          @service.bet! create(:playoff_match), create(:team)
        end.to raise_error(UserServiceError, 'The given team is not involved in the given match')
      end
    end

    context 'with an existing team' do
      let(:match) do
        create(:playoff_match, match_scores: [create(:match_score, team: @team)])
      end

      let(:bet) do
        @service.bet! match, @team
      end

      it 'associates the bet with the given team' do
        expect(@team.bets).to include(bet)
      end

      it 'associates the bet with the given match' do
        expect(match.bets).to include(bet)
      end

      it 'associates the bet with the creating user' do
        expect(@user.bets).to include(bet)
      end
    end

    context 'without a team' do
      context 'on a playoff stage' do
        it 'throws an exception' do
          match = create(:playoff_match)
          match.match_scores << create(:match_score, team: @team)
          expect do
            @service.bet! match, nil
          end.to raise_error(UserServiceError, 'Betting on no team in a playoff match is not supported')
        end
      end

      context 'on a group stage' do
        it 'succeeds' do
          match = create(:group_match)
          match.match_scores << create(:match_score, team: @team)
          bet = @service.bet! match, nil
          expect(match.bets).to include(bet)
          expect(@user.bets).to include(bet)
        end
      end
    end
  end
end
