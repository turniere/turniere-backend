# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoresController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/scores/1').to route_to('scores#show', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/scores/1').to route_to('scores#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/scores/1').to route_to('scores#update', id: '1')
    end
  end
end
