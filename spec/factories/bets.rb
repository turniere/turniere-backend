# frozen_string_literal: true

FactoryBot.define do
  factory :bet do
    user
    team
    match
  end
end
