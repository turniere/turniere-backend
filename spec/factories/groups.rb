# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    transient do
      matches { nil }
      match_count { 4 }
    end

    sequence(:number)
    stage

    after(:create) do |group, evaluator|
      if evaluator.matches.nil?
        create_list(:group_match, evaluator.match_count, group: group)
      else
        evaluator.matches
      end
    end
  end
end
