# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
  before do
    @score = create(:score)
    @owner = @score.owner
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @score.to_param }
      expect(response).to be_successful
    end

    it 'should return the correct score' do
      get :show, params: { id: @score.to_param }
      body = deserialize_response response
      expect(body[:score]).to eq(@score.score)
      expect(body[:team_id]).to eq(@score.team.id.to_s)
      expect(body[:match_id]).to eq(@score.match.id.to_s)
    end
  end

  describe 'PUT #update' do
    let(:valid_update) do
      {
        data: {
          id: @score.id,
          type: 'scores',
          attributes: {
            score: 42
          }
        }
      }
    end

    context 'with valid params' do
      context 'as owner' do
        before(:each) do
          apply_authentication_headers_for @owner
        end

        it 'updates the requested score' do
          put :update, params: { id: @score.to_param }.merge(valid_update)
          @score.reload
          expect(@score.score).to eq(valid_update[:data][:attributes][:score])
        end

        it 'renders a response with the updated team' do
          put :update, params: { id: @score.to_param }.merge(valid_update)
          expect(response).to be_successful
          body = deserialize_response response
          expect(body[:score]).to eq(valid_update[:data][:attributes][:score])
        end
      end

      context 'as another user' do
        before(:each) do
          apply_authentication_headers_for create(:user)
        end

        it 'renders a forbidden error response' do
          put :update, params: { id: @score.to_param }.merge(valid_update)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
