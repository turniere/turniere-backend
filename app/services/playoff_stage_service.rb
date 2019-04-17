# frozen_string_literal: true

class PlayoffStageService
  # Generates the playoff stage given the tournament
  #
  # @param teams [Array] The teams to generate the playoff stages with
  # @return [Array] the generated playoff stages
  def self.generate_playoff_stages(teams)
    playoffs = []
    stage_count = calculate_required_stage_count(teams.size)
    # initial_matches are the matches in the first stage;
    # this is the only stage filled with teams from the start of the playoff stage
    initial_matches = MatchService.generate_matches(teams)
    initial_stage = Stage.new level: stage_count - 1, matches: initial_matches
    playoffs << initial_stage
    # empty stages are the stages, the tournament is filled with to have the matches ready for later
    empty_stages = generate_stages_with_empty_matches(stage_count - 1)
    empty_stages.each do |stage|
      playoffs << stage
    end
    playoffs
  end

  # Generates the playoff stage given the tournament
  #
  # @param tournament [Tournament] The tournament to generate the playoff stages from
  # @return [Array] the generated playoff stages
  def self.generate_playoff_stages_from_tournament(tournament)
    generate_playoff_stages tournament.teams
  end

  # Generates given number of empty stages
  #
  # @param stage_count [Integer] number of stages to generate
  # @return [Array] the generated stages
  def self.generate_stages_with_empty_matches(stage_count)
    empty_stages = []
    stage_count.times do |i|
      stage = Stage.new level: i, matches: generate_empty_matches(2**i)
      empty_stages << stage
    end
    # as we are generating the stages in the wrong order (starting with the lowest number of matches (which is
    # the final stage)) they need to be reversed
    empty_stages.reverse!
  end

  # Generates a number of empty matches to fill later stages
  #
  # @param amount [Integer] the amount of matches to generate
  # @return [Array] the generated matches
  def self.generate_empty_matches(amount)
    matches = []
    amount.times do |i|
      match = Match.new state: :not_ready, position: i
      matches << match
    end
    matches
  end

  # Calculates how many stages are required for given number of teams
  #
  # @param number_of_teams [Integer] the teams number of teams to calculate amount of stages
  # @return [Integer] amount of required stages
  def self.calculate_required_stage_count(number_of_teams)
    if number_of_teams.zero? || number_of_teams == 1
      0
    else
      # black voodoo magic
      stage_count = Math.log(Utils.previous_power_of_two(number_of_teams)) / Math.log(2)
      stage_count.to_int
    end
  end
end
