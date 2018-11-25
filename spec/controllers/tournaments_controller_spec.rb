# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TournamentsController, type: :controller do
  def tournament_ids(response)
    deserialize_list(response).map { |t| t[:id].to_i }
  end
  before do
    @tournament = create(:tournament)
    @user = @tournament.owner
    @another_user = create(:user)
    @private_tournament = create(:tournament, user: @another_user, public: false)
    @teams = create_list(:detached_team, 4)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all public tournaments' do
      get :index
      tournaments = deserialize_list response
      public_tournaments = tournaments.select { |t| t[:public] }
      expect(public_tournaments.size).to eq((Tournament.where public: true).size)
    end

    it 'returns no private tournaments for unauthenticated users' do
      get :index
      tournaments = deserialize_list response
      private_tournaments = tournaments.reject { |t| t[:public] }
      expect(private_tournaments.size).to eq(0)
    end

    it 'returns private tournaments owned by the authenticated user' do
      apply_authentication_headers_for @another_user
      get :index
      expect(tournament_ids(response)).to include(@private_tournament.id)
    end

    it 'returns no private tournaments owned by another user' do
      apply_authentication_headers_for @user
      get :index
      expect(tournament_ids(response)).not_to include(@private_tournament.id)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @tournament.to_param }
      expect(response).to be_successful
    end

    it 'returns the requested tournament' do
      get :show, params: { id: @tournament.to_param }
      expect(deserialize_response(response)[:id].to_i).to eq(@tournament.id)
    end
  end

  describe 'POST #create' do
    let(:create_data) do
      {
        data: {
          type: 'tournaments',
          attributes: {
            name: Faker::Dog.name,
            description: Faker::Lorem.sentence,
            public: false
          },
          relationships: {
            teams: {
              data: @teams.map { |team| { type: 'teams', id: team.id } }
            }
          }
        }
      }
    end

    before(:each) do
      apply_authentication_headers_for @user
    end

    context 'with valid params' do
      it 'creates a new Tournament' do
        expect do
          post :create, params: create_data
        end.to change(Tournament, :count).by(1)
      end

      it 'associates the new tournament with the authenticated user' do
        expect do
          post :create, params: create_data
        end.to change(@user.tournaments, :size).by(1)
      end

      it 'associates the given teams with the created tournament' do
        new_teams = create_list(:detached_team, 4)
        new_teams_create_data = create_data
        new_teams_create_data[:data][:relationships][:teams][:data] = \
          new_teams.map { |team| { type: 'teams', id: team.id } }
        post :create, params: new_teams_create_data
        expect(Tournament.last.teams).to match_array(new_teams)
      end

      it 'renders a JSON response with the new tournament' do
        post :create, params: create_data
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(tournament_url(Tournament.last))
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_update) do
      {
        data: {
          type: 'tournaments',
          id: @tournament.id,
          attributes: {
            name: Faker::Dog.name
          }
        }
      }
    end

    context 'with valid params' do
      context 'without authentication headers' do
        it 'renders a unauthorized error response' do
          put :update, params: { id: @tournament.to_param }.merge(valid_update)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'as owner' do
        before(:each) do
          apply_authentication_headers_for @tournament.owner
        end

        it 'updates the requested tournament' do
          put :update, params: { id: @tournament.to_param }.merge(valid_update)
          @tournament.reload
          expect(@tournament.name).to eq(valid_update[:data][:attributes][:name])
        end

        it 'renders a JSON response with the tournament' do
          put :update, params: { id: @tournament.to_param }.merge(valid_update)
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'as another user' do
        before do
          apply_authentication_headers_for create(:user)
        end

        it 'renders a forbidden error response' do
          put :update, params: { id: @tournament.to_param }.merge(valid_update)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'without authentication headers' do
      it 'renders a unauthorized error response' do
        delete :destroy, params: { id: @tournament.to_param }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'as owner' do
      before(:each) do
        apply_authentication_headers_for @tournament.owner
      end

      it 'destroys the requested tournament' do
        expect do
          delete :destroy, params: { id: @tournament.to_param }
        end.to change(Tournament, :count).by(-1)
      end

      it 'destroys associated teams' do
        expect do
          delete :destroy, params: { id: @tournament.to_param }
        end.to change(Team, :count).by(-@tournament.teams.size)
      end
    end

    context 'as another user' do
      before do
        apply_authentication_headers_for create(:user)
      end

      it 'renders a forbidden error response' do
        delete :destroy, params: { id: @tournament.to_param }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end