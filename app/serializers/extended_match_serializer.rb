# frozen_string_literal: true

class ExtendedMatchSerializer < MatchSerializer
  belongs_to :group
  belongs_to :stage
end
