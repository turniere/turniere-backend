# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  before do
    @group = create(:group)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @group.to_param }
      expect(response).to be_successful
    end

    it 'should return the correct group' do
      get :show, params: { id: @group.to_param }
      body = deserialize_response response
      expect(Group.find_by(id: body[:id])).to eq(@group)
      expect(body[:number]).to eq(@group.number)
      expect(body[:matches].size).to eq(@group.matches.size)
      expect(body[:group_scores].size).to eq(@group.group_scores.size)
    end
  end
end
