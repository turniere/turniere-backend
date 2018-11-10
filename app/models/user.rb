# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  include DeviseTokenAuth::Concerns::User

  validates :username, presence: true, uniqueness: true
end
