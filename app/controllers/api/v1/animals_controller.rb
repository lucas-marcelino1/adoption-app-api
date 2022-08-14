class Api::V1::AnimalsController < ApplicationController
  # before_action :authenticate_api_user!

  def index
    @animals = Animal.all
    render status: :ok, json: @animals
  end

  def create
    @animal = Animal.new(animal_params)
    if @animal.save
      render status: :created, json: {message: 'Animal created successfully.', name: @animal.name, user_name: @animal.user.name}
    else
      render status: :precondition_failed, json: {message: 'Animal was not created!', errors: @animal.errors.full_messages}
    end
  end

  # def my_animals
  #   current_api_user.animals
  # end

  private

  def animal_params
    params.require(:animal).permit(:name, :gender, :specie, :age, :size, :user_id)
  end
end