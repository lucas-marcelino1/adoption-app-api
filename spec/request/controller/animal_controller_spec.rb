require 'rails_helper'
include ActionController::RespondWith

RSpec.describe Api::V1::AnimalsController, :type => :controller do
  describe 'GET index' do
    it 'successfully' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      request.headers.merge! user.create_new_auth_token
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'unauthorized' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST create' do
    it 'successfully' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      animal_params = {animal: {name:'Tunico', age: '0.11', specie: 'Cat', gender: 'Male', size: 'Small', user_id: user.id }}
      request.headers.merge! user.create_new_auth_token
      post :create, params: animal_params
      expect(response).to have_http_status(:created)
    end

    it 'unauthorized' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      animal_params = {animal: {name:'Tunico', age: '0.11', specie: 'Cat', gender: 'Male', size: 'Small', user_id: user.id }}
      post :create, params: animal_params
      expect(response).to have_http_status(:unauthorized)
    end

  end
end