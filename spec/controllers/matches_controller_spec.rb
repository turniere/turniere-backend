# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  before do
    @match = create(:match, state: :not_started)
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

  describe 'POST #update' do
    let(:valid_update) do
      {
        state: 'in_progress'
      }
    end

    let(:invalid_update) do
      {
        state: 'team1_won'
      }
    end

    context 'as owner' do
      before(:each) do
        apply_authentication_headers_for @match.owner
      end

      context 'with valid params' do
        it 'updates the match' do
          put :update, params: { id: @match.to_param }.merge(valid_update)
          @match.reload
          expect(response).to be_successful
          expect(@match.state).to eq(valid_update[:state])
        end

        it 'renders a response with the updated match' do
          put :update, params: { id: @match.to_param }.merge(valid_update)
          expect(response).to be_successful
          body = deserialize_response response
          expect(body[:state]).to eq(valid_update[:state])
        end
      end

      context 'with invalid params' do
        it 'renders an unprocessable entity response' do
          put :update, params: { id: @match.to_param }.merge(invalid_update)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'as another user' do
      context 'with valid params' do
        before(:each) do
          apply_authentication_headers_for create(:user)
        end

        it 'renders a forbidden error response' do
          put :update, params: { id: @match.to_param }.merge(valid_update)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
