# frozen_string_literal: true

FactoryBot.define do
  factory :tournament do
    name { Faker::Dog.name }
    description { Faker::Lorem.sentence }
    user
  end
end
