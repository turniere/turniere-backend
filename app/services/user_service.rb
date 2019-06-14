# frozen_string_literal: true

class UserService
  def initialize(user)
    @user = user
  end

  def bet!(match, team)
    validate_bet! match, team
    @user.bets.create! match: match, team: team
  end

  private

  def validate_bet!(match, team)
    if team.nil?
      raise UserServiceError, 'Betting on no team in a playoff match is not supported' unless match.group_match?
    else
      raise UserServiceError, 'The given team is not involved in the given match' unless match.teams.include? team
    end
  end
end
