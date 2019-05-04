# frozen_string_literal: true

FactoryBot.define do
  factory :stage do
    tournament
    factory :group_stage do
      level { -1 }
      transient do
        group_count { 4 }
      end
      after(:create) do |stage, evaluator|
        stage.groups = create_list(:group, evaluator.group_count)
      end
    end

    factory :playoff_stage do
      level { rand(10) }
      transient do
        match_count { 4 }
      end
      after(:create) do |stage, evaluator|
        stage.matches = create_list(:match, evaluator.match_count)
      end
    end
  end
end
