# frozen_string_literal: true

FactoryBot.define do
  factory :score do
    score { rand(0..10) }
    match
    team
  end
end
