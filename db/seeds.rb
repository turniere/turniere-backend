# frozen_string_literal: true

require 'faker'

user = User.create! username: Faker::Internet.username, email: Faker::Internet.email, password: Faker::Internet.password
tournament = user.tournaments.create! name: Faker::Dog.name
team1 = tournament.teams.create name: Faker::Dog.name
team2 = tournament.teams.create name: Faker::Dog.name
stage = tournament.stages.create!
match = stage.matches.create!
match.scores.create! team: team1, score: 0
match.scores.create! team: team2, score: 1
