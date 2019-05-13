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
      state { :in_progress }
    end

    factory :decided_playoff_match do
      transient do
        match_scores_count { 2 }
      end
      after(:create) do |match, evaluator|
        match.match_scores = create_list(:match_score, evaluator.match_scores_count, points: rand(10))
        match.match_scores.first.points += 1
      end
      state { :team1_won }
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
      state { :in_progress }
    end

    factory :undecided_group_match do
      transient do
        match_scores_count { 2 }
      end
      after(:create) do |match, evaluator|
        match.match_scores = create_list(:match_score, evaluator.match_scores_count, points: 3)
      end
      state { :team1_won }
    end
  end
end
