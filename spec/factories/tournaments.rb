# frozen_string_literal: true

FactoryBot.define do
  factory :tournament, aliases: [:stageless_tournament] do
    name { Faker::Creature::Dog.name }
    description { Faker::Lorem.sentence }
    user
    transient do
      teams_count { 8 }
    end
    after(:create) do |tournament, evaluator|
      tournament.teams = create_list(:team, evaluator.teams_count, tournament: tournament)
    end

    factory :stage_tournament do
      transient do
        stage_count { 1 }
      end
      after(:create) do |tournament, evaluator|
        # this is basically a manual create_list as we need to count up the level of the stage
        levels = 1..evaluator.stage_count

        tournament.stages.concat(levels.map do |level|
                                   create(:playoff_stage,
                                          level: level,
                                          match_count: -1,
                                          match_type: if evaluator.stage_count
                                                        :running_playoff_match
                                                      else
                                                        :empty_prepared_playoff_match
                                                      end)
                                 end)
      end

      factory :group_stage_tournament do
        after(:create) do |tournament, _evaluator|
          tournament.stages << create(:group_stage)
        end
      end
    end

    factory :dummy_stage_tournament do
      transient do
        stage_count { 3 }
      end
      after(:create) do |tournament, evaluator|
        tournament.stages.concat create_list(:stage, evaluator.stage_count)
      end
    end
  end
end
