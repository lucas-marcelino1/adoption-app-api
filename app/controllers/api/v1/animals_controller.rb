class Api::V1::AnimalsController < ApplicationController
  before_action :authenticate_api_user!
  before_action :verify_user, only: [:update, :destroy]

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

  def update
    @animal = Animal.find(params[:id])
    if @animal.update(animal_params)
      render status: :ok, json: {message: 'Animal update successfully.', animal: @animal}
    else
      render status: :precondition_failed, json: {message: 'Animal was not update!', errors: @animal.errors.full_messages}
    end
  end

  def destroy
    @animal = Animal.find(params[:id])
    if @animal.delete
      render status: :ok, json: {message: 'Animal deleted successfully.'}
    else
      render status: :internal_server_error, json: {message: "Something went wrong"}
    end
  end

  private

  def animal_params
    params.require(:animal).permit(:name, :gender, :specie, :age, :size, :user_id)
  end

  def verify_user
    @animal = Animal.find(params[:id])
    if current_api_user != @animal.user
      render status: :unauthorized, json: { errors: { title: 'User not authorized.', 
                                        details: "You have no authorization to do this." }}
    end
  end
end