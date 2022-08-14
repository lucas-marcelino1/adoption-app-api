# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :registration_number, format: {with: /([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})/ }
  validates :registration_number, uniqueness: true
  validates :registration_number, presence: true
  has_many :animals
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  include DeviseTokenAuth::Concerns::User
end
