# frozen_string_literal: true

FactoryBot.define do
  factory :score do
    score { 0 }
    match
    team
  end
end
