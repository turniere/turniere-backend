# frozen_string_literal: true

require 'securerandom'

class Tournament < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  has_many :teams, dependent: :destroy
  belongs_to :user

  alias_attribute :owner, :user

  after_initialize do |tournament|
    tournament.code ||= SecureRandom.hex 3
  end
end
