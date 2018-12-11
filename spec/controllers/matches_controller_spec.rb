# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  before do
    @match = create(:match)
    @match.match_scores = create_pair(:match_score)
  end

  describe 'GET #show' do
    it 'should return success' do
      get :show, params: { id: @match.to_param }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json')
    end

    it 'should return the correct state' do
      get :show, params: { id: @match.to_param }
      body = deserialize_response response
      expect(body[:state]).to eq(@match.state)
      expect(body[:match_scores].map { |ms| ms[:id] }).to eq(@match.match_scores.map(&:id))
    end
  end
end
