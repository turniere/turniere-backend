# frozen_string_literal: true

module Turniere
  class GroupStage
    def self.generate_playoffs(teams, _tournament)
      stage_count = calculate_required_stage_count(teams.size)
      generate_matches(teams)
    end

    def self.calculate_required_stage_count(number_of_teams)
      if number_of_teams.zero? || number_of_teams == 1
        0
      else
        Math.log(Turniere::Utils.previous_power_of_two(number_of_teams)) / Math.log(2)
      end
    end
  end
end
