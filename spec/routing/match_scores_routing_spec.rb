# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchScoresController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/match_scores/1').to route_to('match_scores#show', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/match_scores/1').to route_to('match_scores#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/match_scores/1').to route_to('match_scores#update', id: '1')
    end
  end
end
