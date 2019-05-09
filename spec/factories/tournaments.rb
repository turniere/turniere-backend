# frozen_string_literal: true

FactoryBot.define do
  factory :tournament do
    name { Faker::Creature::Dog.name }
    description { Faker::Lorem.sentence }
    user
    transient do
      teams_count { 16 }
    end
    after(:create) do |tournament, evaluator|
      tournament.teams = create_list(:team, evaluator.teams_count, tournament: tournament)
    end

    factory :stage_tournament do
      transient do
        stage_count { 1 }
      end
      after(:create) do |tournament, evaluator|
        tournament.stages = create_list(:stage, evaluator.stage_count)
      end

      factory :group_stage_tournament do
        after(:create) do |tournament, _evaluator|
          tournament.stages << create(:group_stage)
        end
      end
    end
  end
end
