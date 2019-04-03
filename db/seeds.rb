# frozen_string_literal: true

require 'faker'

user = User.create! username: Faker::Internet.username, email: Faker::Internet.email, password: Faker::Internet.password
tournament = user.tournaments.create! name: Faker::Creature::Dog.name

@teams = []
16.times do
  team = tournament.teams.create! name: Faker::HarryPotter.character
  @teams << team
end
4.times do |i|
  stage = tournament.stages.create!
  stage.level = i
  matches_amount = 2**i
  matches_amount.times do |j|
    match = stage.matches.create!
    match.match_scores.create! team: @teams.sample, points: rand(10)
    match.match_scores.create! team: @teams.sample, points: rand(10)
    match.position = j
    match.state = rand(7)
    match.save!
  end
  stage.save!
end
