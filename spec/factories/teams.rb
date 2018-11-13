# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Dog.name }
    group_score
  end
end
