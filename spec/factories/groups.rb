# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:number)
    stage
    group_match
  end
end
