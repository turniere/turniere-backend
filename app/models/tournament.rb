# frozen_string_literal: true

require 'securerandom'

class Tournament < ApplicationRecord
  belongs_to :user
  has_many :teams, dependent: :destroy
  has_many :stages, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  alias_attribute :owner, :user

  after_initialize do |tournament|
    tournament.code ||= SecureRandom.hex 3
  end
end
