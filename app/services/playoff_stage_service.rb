# frozen_string_literal: true

class PlayoffStageService
  def self.generate_playoff_stages(teams)
    playoffs = []
    stage_count = calculate_required_stage_count(teams.size)
    initial_matches = MatchService.generate_matches(teams)
    initial_stage = Stage.new level: stage_count - 1, matches: initial_matches
    playoffs << initial_stage
    empty_stages = generate_stages_with_empty_matches(stage_count - 1)
    empty_stages.each do |stage|
      playoffs << stage
    end
    playoffs
  end

  def self.generate_playoff_stages_from_tournament(tournament)
    generate_playoff_stages tournament.teams
  end

  def self.generate_stages_with_empty_matches(stage_count)
    empty_stages = []
    stage_count.times do |i|
      stage = Stage.new level: i, matches: generate_empty_matches(2**i)
      empty_stages << stage
    end
    empty_stages.reverse!
  end

  def self.generate_empty_matches(amount)
    matches = []
    amount.times do |i|
      match = Match.new state: :not_ready, position: i
      matches << match
    end
    matches
  end

  def self.calculate_required_stage_count(number_of_teams)
    if number_of_teams.zero? || number_of_teams == 1
      0
    else
      stage_count = Math.log(Utils.previous_power_of_two(number_of_teams)) / Math.log(2)
      stage_count.to_int
    end
  end
end
