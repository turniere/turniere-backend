# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Creature::Dog.name }
  end
end
