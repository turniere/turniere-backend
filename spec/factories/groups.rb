# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    transient do
      match_count { 4 }
    end

    sequence(:number)
    stage

    after(:create) do |group, evaluator|
      create_list(:group_match, evaluator.match_count, group: group)
    end
  end
end
