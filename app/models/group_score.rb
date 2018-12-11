# frozen_string_literal: true

class GroupScore < ApplicationRecord
  belongs_to :team
  belongs_to :group

  # :)
  alias_attribute :received_points, :recieved_points
end
