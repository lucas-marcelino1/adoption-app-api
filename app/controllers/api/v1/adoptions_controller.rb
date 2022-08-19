class Api::V1::AdoptionsController < ApplicationController
  before_action :authenticate_api_user!

  def index
    @adoptions = Adoption.all
    if @adoptions.any?
      render status: :ok, json: @adoptions.as_json(only: [:description, :title, :id],
                                                   include: [animal: {only: [:specie, :gender]}])
    else
      render status: :ok, json: {message: 'None adoptions registred yet.'}
    end
  end

  def show
    @adoption = Adoption.find(params[:id])
    render status: :ok, json: @adoption
  end
end
