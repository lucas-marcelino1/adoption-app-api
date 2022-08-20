class Api::V1::AdoptionsController < ApplicationController
  before_action :authenticate_api_user!
  before_action :set_adoption, only: [:show]
  before_action :verify_user, only: [:adopt]

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
    render status: :ok, json: @adoption
  end

  def create
    @adoption = Adoption.new(params.require(:adoption).permit(:title, :description, :animal_id, :user_id))
    if @adoption.save
      render status: :created, json: {message: 'Adoption created successfully.', adoption: {title: @adoption.title, animal: @adoption.animal.name, user: @adoption.user.name}}
    else
      render status: :precondition_failed, json: {message: "Adoption was not created!", errors: @adoption.errors.full_messages}
    end
  end

  def adopt
    @adoption = Adoption.find(params[:adoption_id])
    @user_adopt = User.find_by(email: params[:user_email])
    if @adoption.animal.update(user: @user_adopt)
      @adoption.animal.adopted!
      render status: :ok, json: {message: 'Animal adopted successfully.'}
    else
      raise StandardError
    end
  end

  private

  def verify_user
    @adoption = Adoption.find(params[:id])
    if current_api_user != @adoption.user
      render status: :unauthorized, json: { errors: { title: 'User not authorized.', 
                                        details: "You have no authorization to do this." }}
    end
  end

  def set_adoption
    @adoption = Adoption.find(params[:id])
  end
end
