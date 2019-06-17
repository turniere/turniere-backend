# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BetsController, type: :controller do
  let(:team) do
    create(:team)
  end

  let(:match) do
    match = create(:playoff_match)
    match.bets << create(:bet, team: team)
    match
  end

  let(:params) do
    {
      match_id: match.to_param
    }
  end

  describe 'GET #index' do
    it 'returns a list of bet counts' do
      get :index, params: params
      body = deserialize_response response
      expect(body.size).to eq(1)
      expect(body.first[:team][:id]).to eq(team.id)
      expect(body.first[:bets]).to eq(1)
    end
  end

  describe 'POST #create' do
    let(:create_params) do
      params.merge(team: team.to_param)
    end

    let(:user_service) do
      instance_double('UserService')
    end

    before do
      allow(controller).to receive(:user_service).and_return(user_service)
    end

    context 'without authentication headers' do
      it 'renders an unauthorized error response' do
        post :create, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication headers' do
      before(:each) do
        apply_authentication_headers_for create(:user)
      end

      it 'returns the created bet' do
        bet = create(:bet)
        expect(user_service).to receive(:bet!).and_return(bet)
        post :create, params: create_params
        expect(response).to be_successful
        body = deserialize_response(response)
        expect(body[:id]).to eq(bet.id)
      end

      context 'given a team' do
        it 'calls the service' do
          expect(user_service).to receive(:bet!).with(match, team)
          post :create, params: create_params
        end
      end

      context 'given no team' do
        it 'calls the service' do
          expect(user_service).to receive(:bet!).with(match, nil)
          post :create, params: params.merge(team: nil)
        end
      end

      context 'on service exception' do
        it 'returns an error response' do
          msg = 'an error'
          expect(user_service).to receive(:bet!).and_raise(UserServiceError, msg)
          post :create, params: create_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(deserialize_response(response)[:error]).to eq(msg)
        end
      end
    end
  end
end
