# frozen_string_literal: true

FactoryBot.define do
  factory :playoff_match, aliases: [:match], class: Match do
    stage
    factory :running_playoff_match do
      transient do
        scores_count { 2 }
      end
      after(:create) do |match, evaluator|
        match.scores = create_list(:score, evaluator.scores_count)
      end
      state { 3 }
    end
  end

  factory :group_match, class: Match do
    group
  end
end
