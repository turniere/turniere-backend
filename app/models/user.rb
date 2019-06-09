# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :tournaments, dependent: :destroy
  has_many :bets, dependent: :destroy
end
