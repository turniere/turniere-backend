# frozen_string_literal: true

FactoryBot.define do
  factory :stage do
    tournament

    factory :group_stage do
      level { -1 }
      state { :in_progress }
      transient do
        group_count { 4 }
        match_factory { :group_match }
      end
      after(:create) do |stage, evaluator|
        stage.groups = create_list(:group, evaluator.group_count, match_factory: evaluator.match_factory)
        stage.tournament.stages << stage
        stage.save!
      end
    end

    factory :playoff_stage do
      level { rand(10) }
      transient do
        match_type { :running_playoff_match }
        match_count { 4 }
      end
      after(:create) do |stage, evaluator|
        stage.matches = create_list(evaluator.match_type,
                                    evaluator.match_count == -1 ? 2**stage.level : evaluator.match_count)
        stage.matches.each_with_index do |match, i|
          match.position = i
        end
        stage.tournament.stages << stage
        stage.save!
      end
    end

    factory :decided_group_stage do
      level { -1 }
      state { :finished }
      transient do
        group_count { 8 }
        match_factory { :decided_group_match }
      end
      after(:create) do |stage, evaluator|
        stage.groups = create_list(:group, evaluator.group_count, match_factory: evaluator.match_factory)
        stage.tournament.stages << stage
        stage.save!
      end
    end
  end
end