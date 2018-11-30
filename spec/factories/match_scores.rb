# frozen_string_literal: true

FactoryBot.define do
  factory :match_score do
    points { rand(0..10) }
    match
    team
  end
end
