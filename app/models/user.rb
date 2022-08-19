# frozen_string_literal: true

class User < ActiveRecord::Base
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address
  has_many :animals, dependent: :destroy
  has_many :adoptions, dependent: :destroy
  validates :registration_number, :address, presence: true
  validates :registration_number, uniqueness: true
  validates :registration_number, format: {with: /([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})/ }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  include DeviseTokenAuth::Concerns::User
end
