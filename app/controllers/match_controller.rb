# frozen_string_literal: true

class MatchController < ApplicationController
  def get
    id = params[:id]
    Match
  end
end
