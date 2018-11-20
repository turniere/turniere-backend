# frozen_string_literal: true

FactoryBot.define do
  factory :stage_match, aliases: [:match], class: Match do
    stage
  end

  factory :group_match, class: Match do
    group
  end
end
