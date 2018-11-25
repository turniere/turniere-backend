# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  before do
    @match = create(:match)
    @match.scores = create_pair(:score)
  end

  describe 'GET #show' do
    it 'should return success' do
      get :show, params: { id: @match.to_param }
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json')
    end

    it 'should return the correct state' do
      get :show, params: { id: @match.to_param }
      body = ActiveModelSerializers::Deserialization.jsonapi_parse(JSON.parse(response.body))
      expect(body[:state]).to be(@match.state)
      expect(body[:score_ids]).to eq(@match.scores.map { |score| score.id.to_s })
    end
  end
end
