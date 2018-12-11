# frozen_string_literal: true

class GroupSerializer < ApplicationSerializer
  attributes :number

  has_many :matches
  has_many :group_scores
end
