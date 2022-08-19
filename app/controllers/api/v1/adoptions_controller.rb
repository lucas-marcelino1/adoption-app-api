class Api::V1::AdoptionsController < ApplicationController
  before_action :authenticate_api_user!

  def index
    @adoptions = Adoption.all
    render status: :ok, json: @adoptions
  end
end