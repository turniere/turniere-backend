# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  before do
    @team = create(:team)
    @owner = @team.owner
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @team.to_param }
      expect(response).to be_successful
    end

    it 'should return the correct team' do
      get :show, params: { id: @team.to_param }
      body = ActiveModelSerializers::Deserialization.jsonapi_parse(JSON.parse(response.body))
      expect(body[:name]).to eq(@team.name)
    end
  end

  describe 'PUT #update' do
    let(:valid_update) do
      {
        data: {
          id: @team.id,
          type: 'teams',
          attributes: {
            name: Faker::Dog.name
          }
        }
      }
    end

    context 'with valid params as owner' do
      before(:each) do
        apply_authentication_headers_for @owner
      end

      it 'updates the requested team' do
        put :update, params: { id: @team.to_param }.merge(valid_update)
        @team.reload
        expect(response).to be_successful
        expect(@team.name).to eq(valid_update[:data][:attributes][:name])
      end

      it 'renders a response with the updated team' do
        put :update, params: { id: @team.to_param }.merge(valid_update)
        expect(response).to be_successful
        body = ActiveModelSerializers::Deserialization.jsonapi_parse(JSON.parse(response.body))
        expect(body[:name]).to eq(valid_update[:data][:attributes][:name])
      end
    end

    context 'with valid params as another user' do
      before(:each) do
        apply_authentication_headers_for create(:user)
      end

      it 'renders a forbidden error response' do
        put :update, params: { id: @team.to_param }.merge(valid_update)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
