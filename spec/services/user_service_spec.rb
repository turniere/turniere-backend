# frozen_string_literal: true

RSpec.describe UserService do
  let(:user) do
    create(:user)
  end

  let(:user_service) do
    UserService.new(user)
  end

  let(:team) do
    create(:team)
  end

  def build_match(involved_team = team, factory = :playoff_match)
    create(factory, state: :not_started, match_scores: [create(:match_score, team: involved_team)])
  end

  describe '#bet!' do
    context 'with an unrelated team' do
      it 'throws an exception' do
        expect do
          user_service.bet! build_match(create(:team)), team
        end.to raise_error(UserServiceError, 'The given team is not involved in the given match')
      end
    end

    context 'on a running match' do
      it 'throws an exception' do
        match = build_match
        match.state = :in_progress
        expect do
          user_service.bet! match, team
        end.to raise_error(UserServiceError, 'Betting is not allowed while match is in_progress')
      end
    end

    context 'with an existing team' do
      let(:match) do
        build_match
      end

      let!(:bet) do
        user_service.bet! match, team
      end

      it 'associates the bet with the given team' do
        expect(team.bets.reload).to include(bet)
      end

      it 'associates the bet with the given match' do
        expect(match.bets.reload).to include(bet)
      end

      it 'associates the bet with the creating user' do
        expect(user.bets.reload).to include(bet)
      end

      context 'with an already existing bet' do
        it 'throws an exception' do
          match = build_match
          user_service.bet! match, team
          user.reload
          match.reload
          expect do
            user_service.bet! match, team
          end.to raise_error(UserServiceError, 'This user already created a bet on this match')
        end
      end
    end

    context 'without a team' do
      context 'on a playoff stage' do
        it 'throws an exception' do
          expect do
            user_service.bet! build_match, nil
          end.to raise_error(UserServiceError, 'Betting on no team in a playoff match is not supported')
        end
      end

      context 'on a group stage' do
        it 'succeeds' do
          user_service.bet! build_match(team, :group_match), nil
        end
      end
    end
  end
end
