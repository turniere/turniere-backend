# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StagesController, type: :controller do
  before do
    @stage = create(:playoff_stage)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @stage.to_param }
      expect(response).to be_successful
    end

    it 'should return the correct stage' do
      get :show, params: { id: @stage.to_param }
      body = deserialize_response response
      expect(Stage.find_by(id: body[:id])).to eq(@stage)
      expect(body[:level]).to eq(@stage.level)
      expect(body[:state]).to eq(@stage.state)
    end
  end

  describe 'PUT #update' do
    context 'group_stage with matches that are done' do
      before do
        @running_group_stage = create(:group_stage, match_factory: :finished_group_match)
      end

      FINISHED = { state: 'finished' }.freeze

      it 'doesn\'t have any other stages besides it before update' do
        expect(@running_group_stage.tournament.stages.size).to eq(1)
      end

      context 'as owner' do
        before(:each) do
          apply_authentication_headers_for @running_group_stage.owner
        end

        before do
          put :update, params: { id: @running_group_stage.to_param }.merge(FINISHED)
          @running_group_stage.reload
        end

        it 'succeeds' do
          expect(response).to be_successful
        end

        it 'stops the stage' do
          expect(@running_group_stage.state).to eq(FINISHED[:state])
        end

        it 'adds new stages to the tournament' do
          expect(@running_group_stage.tournament.stages.size).to be > 1
        end

        it 'adds the right teams' do
          expect(@running_group_stage.tournament.stages.max_by(&:level).teams)
            .to match_array(GroupStageService.get_advancing_teams(@running_group_stage))
        end
      end

      context 'as another user' do
        before(:each) do
          apply_authentication_headers_for create(:user)
        end

        it 'returns an error' do
          put :update, params: { id: @stage.to_param }.merge(FINISHED)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'already finished group stage' do
      let(:finished_group_stage) do
        group_stage = create(:group_stage, match_factory: :finished_group_match)
        group_stage.finished!
        group_stage.save!
        group_stage
      end

      before do
        apply_authentication_headers_for finished_group_stage.owner
        put :update, params: { id: finished_group_stage.to_param }.merge(state: 'finished')
      end

      it 'it returns unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error' do
        expect(deserialize_response(response)[:error]).to eq('Only running group stages can be finished')
      end
    end
  end
end
