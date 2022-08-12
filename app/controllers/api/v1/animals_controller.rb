class Api::V1::AnimalsController < ApplicationController
  def index
    @animals = Animal.all
    render status: :ok, json: @animals
  end
end