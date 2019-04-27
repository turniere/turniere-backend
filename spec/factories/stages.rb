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
  end
end
