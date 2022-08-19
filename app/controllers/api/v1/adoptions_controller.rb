class Api::V1::AdoptionsController < ApplicationController
  before_action :authenticate_api_user!

  def index
    @adoptions = Adoption.all
    if @adoptions.any?
      render status: :ok, json: @adoptions
    else
      render status: :ok, json: {message: 'None adoptions registred yet.'}
    end
  end
end