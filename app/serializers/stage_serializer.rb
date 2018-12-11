# frozen_string_literal: true

class StageSerializer < ApplicationSerializer
  attributes :level

  has_many :matches
  has_many :groups
end
