# frozen_string_literal: true

FactoryBot.define do
  factory :playoff_match, aliases: [:match], class: Match do
    stage
    factory :running_playoff_match do
      transient do
        match_scores_count { 2 }
      end
      after(:create) do |match, evaluator|
        match.match_scores = create_list(:match_score, evaluator.match_scores_count)
      end
      state { 3 }
    end
  end

  factory :group_match, class: Match do
    group
    factory :running_group_match do
      transient do
        match_scores_count { 2 }
      end
      after(:create) do |match, evaluator|
        match.match_scores = create_list(:match_score, evaluator.match_scores_count)
      end
      state { 3 }
    end
  end
end
