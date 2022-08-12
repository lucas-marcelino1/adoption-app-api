class Api::V1::AnimalsController < ActionController::API
  def index
    @animals = Animal.all
    render status: :ok, json: @animals
  end
end