# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatisticsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/tournaments/1/statistics').to route_to('statistics#index', tournament_id: '1')
    end
  end
end
