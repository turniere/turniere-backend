# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[show]

  # GET /groups/1
  def show
    render json: @group, include: '**'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
