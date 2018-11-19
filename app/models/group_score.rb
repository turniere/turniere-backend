# frozen_string_literal: true

class GroupScore < ApplicationRecord
  belongs_to :team
  belongs_to :group
end
