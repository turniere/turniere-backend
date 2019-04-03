# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  include DeviseTokenAuth::Concerns::User

  validates :username, presence: true, uniqueness: true

  has_many :tournaments, dependent: :destroy
end
