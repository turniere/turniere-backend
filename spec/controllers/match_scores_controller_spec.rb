# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchScoresController, type: :controller do
  before do
    @match_score = create(:running_playoff_match).match_scores.first
    @owner = @match_score.owner
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @match_score.to_param }
      expect(response).to be_successful
    end

    it 'should return the correct score' do
      get :show, params: { id: @match_score.to_param }
      body = deserialize_response response
      expect(body[:points]).to eq(@match_score.points)
      expect(body[:team][:id]).to eq(@match_score.team.id)
    end
  end

  describe 'PUT #update' do
    let(:valid_update) do
      {
        points: 42
      }
    end

    context 'with valid params' do
      context 'as owner' do
        before(:each) do
          apply_authentication_headers_for @owner
        end

        it 'updates the requested score' do
          put :update, params: { id: @match_score.to_param }.merge(valid_update)
          @match_score.reload
          expect(@match_score.points).to eq(valid_update[:points])
        end

        it 'renders a response with the updated team' do
          put :update, params: { id: @match_score.to_param }.merge(valid_update)
          expect(response).to be_successful
          body = deserialize_response response
          expect(body[:points]).to eq(valid_update[:points])
        end
      end

      context 'as another user' do
        before(:each) do
          apply_authentication_headers_for create(:user)
        end

        it 'renders a forbidden error response' do
          put :update, params: { id: @match_score.to_param }.merge(valid_update)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
