# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/teams/1').to route_to('teams#show', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/teams/1').to route_to('teams#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/teams/1').to route_to('teams#update', id: '1')
    end
  end
end
