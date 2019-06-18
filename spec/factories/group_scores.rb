# frozen_string_literal: true

FactoryBot.define do
  factory :group_score do
    team
    group

    group_points { rand 5 }
    scored_points { rand 5 }
    received_points { rand 5 }
  end
end
