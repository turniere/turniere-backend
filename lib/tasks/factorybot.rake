# frozen_string_literal: true

namespace :factorybot do
  desc 'Lint FactoryBot factories'
  task :lint do |_|
    FactoryBot.lint
  end
end
