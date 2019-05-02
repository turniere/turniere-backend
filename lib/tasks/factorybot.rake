# frozen_string_literal: true

namespace :factorybot do
  desc 'Lint FactoryBot factories'
  task lint: :environment do
    FactoryBot.lint
  end
end
