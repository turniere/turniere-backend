# frozen_string_literal: true

class PlayoffStageService
  # Generates the playoff stage given the tournament
  #
  # @param teams [Array] The teams to generate the playoff stages with
  # @return [Array] the generated playoff stages
  def self.generate_playoff_stages(teams)
    playoffs = []
    stage_count = calculate_required_stage_count(teams.size)
    # initial_matches are the matches in the first stage; this is the only stage filled with teams from the start on
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
    if number_of_teams == 1
      1
    else
      # black voodoo magic
      stage_count = Math.log(Utils.next_power_of_two(number_of_teams)) / Math.log(2)
      stage_count -= 1 if Utils.po2?(number_of_teams)
      stage_count.to_int
    end
  end


  def self.populate_match_below(current_match)
    current_stage = current_match.stage
    next_stage = current_stage.tournament.stages.find { |s| s.level == current_stage.level - 1 }
    return if next_stage.nil?

    current_position = current_match.position
    next_position = current_position / 2

    companion_match_position = current_position.even? ? current_position + 1 : current_position - 1
    companion_match = current_stage.matches.find { |m| m.position == companion_match_position }

    match_below = next_stage.matches.find { |m| m.position == next_position }

    match_scores = match_below.match_scores.sort_by(&:id)
    matches = [current_match, companion_match].sort_by(&:position)
    winners = if companion_match.finished?
                matches.map(&:winner)
              else
                matches.map do |m|
                  m == current_match ? m.winner : nil
                end
              end

    # depending on the amount of match_scores already present we need to do different things
    case match_scores.size
    when 0
      # when 0 match_scores are already there we create both of them with the respective winner from above
      match_scores = winners.map { |winner| MatchScore.new(team: winner) }
    when 1
      # when 1 match_score is present, we need to check which team is contained within and add the other team as well
      team = nil

      if match_scores.first.team == winners.first
        team = winners.second
      elsif match_scores.first.team == winners.second
        team = winners.first
      else
        match_scores.first.team = winners.first
        team = winners.second
      end

      match_scores.concat MatchScore.new(team: team)
    when 2
      match_scores.first.team = winners.first
      match_scores.second.team = winners.second
    end

    # If a match is not decided yet, it will return nil as winner.
    # This is not allowed in Database. The following code filters out MatchScores that contain nil as team.
    match_scores = match_scores.select { |ms| ms.team.present? }
    match_below.match_scores = match_scores
  end
end
