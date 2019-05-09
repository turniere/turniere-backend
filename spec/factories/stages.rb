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
        # match_count -1 automatically generates 2 ^ stage.level matches
        # (as this would be the amount of stages present in the real world)
        stage.matches = create_list(:match, evaluator.match_count == -1 ? 2**stage.level : evaluator.match_count)
        stage.matches.each_with_index { |match, i| match.position = i }
      end
    end
  end
end
