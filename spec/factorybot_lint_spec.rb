# frozen_string_literal: true

# spec/lint_spec.rb

require 'rails_helper'

RSpec.describe 'Lint' do
  it 'FactoryBot factories' do
    conn = ActiveRecord::Base.connection
    conn.transaction do
      FactoryBot.lint
      raise ActiveRecord::Rollback
    end
  end
end
