# frozen_string_literal: true

require 'faker'

user = User.create! username: Faker::Internet.username, email: Faker::Internet.email, password: Faker::Internet.password
tournament = user.tournaments.create! name: Faker::Dog.name
team1 = tournament.teams.create name: Faker::Dog.name
team2 = tournament.teams.create name: Faker::Dog.name
stage = tournament.stages.create!
match = stage.matches.create!
match.match_scores.create! team: team1, points: 0
match.match_scores.create! team: team2, points: 1
