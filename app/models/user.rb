# frozen_string_literal: true

class User < ActiveRecord::Base
  validates :registration_number, format: {with: /([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})/ }
  validates :registration_number, uniqueness: true
  validates :registration_number, :address, presence: true
  has_one :address
  accepts_nested_attributes_for :address
  has_many :animals, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  include DeviseTokenAuth::Concerns::User
end
