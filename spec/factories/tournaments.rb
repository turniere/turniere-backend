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
      tournament.playoff_teams_amount = (tournament.teams.size / 2)
      tournament.instant_finalists_amount = (tournament.playoff_teams_amount / 2)
      tournament.intermediate_round_participants_amount = ((tournament.playoff_teams_amount -
                                                            tournament.instant_finalists_amount) * 2)
      tournament.save!
    end

    factory :stage_tournament do
      transient do
        stage_count { 1 }
      end
      after(:create) do |tournament, evaluator|
        # this is basically a manual create_list as we need to count up the level of the stage
        (1..evaluator.stage_count).each do |level|
          tournament.stages << create(
            :playoff_stage,
            level: level,
            match_count: -1,
            match_type: level == evaluator.stage_count ? :running_playoff_match : :empty_prepared_playoff_match
          )
          tournament.stages.each do |stage|
            stage.matches.each_with_index do |match, i|
              match.position = i
              match.save!
            end
          end
        end
      end

      factory :group_stage_tournament do
        transient do
          group_count { 2 }
          match_factory { :group_match }
        end
        after(:create) do |tournament, evaluator|
          tournament.stages << create(:group_stage,
                                      match_factory: evaluator.match_factory,
                                      group_count: evaluator.group_count)
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
