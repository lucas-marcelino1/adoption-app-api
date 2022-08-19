require 'rails_helper'

RSpec.describe 'User', :type => :request do
  describe 'POST api/auth' do
    it 'create user successfully' do
      user_params = {email: "new_user@email.com", name: "New User", registration_number: "111.222.333-45",
                    password: "123456", password_confirmation: "123456", address_attributes:
                      {city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444',
                       details: 'Rua Dr. Antônio Hafner, 540'}}

      post('/api/auth', params: user_params)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(User.last.address.city).to eq('Blumenau')
      expect(User.last.address.state).to eq('Santa Catarina')
      expect(User.last.address.zipcode).to eq('89026-444')
    end

    it 'create user with invalid data' do
      user_params = {email: "new_user@email.com", name: "New User", registration_number: "111.222.33-45",
                     password: "123456", password_confirmation: "12356", address_attributes:
                             {city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444',
                              details: 'Rua Dr. Antônio Hafner, 540'}}

      post('/api/auth', params: user_params)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['errors']["full_messages"]).to include('Registration number is invalid')
      expect(json_response['errors']["full_messages"]).to include("Password confirmation doesn't match Password")
    end
  end

  describe 'POST api/auth/sign_in' do
    it 'log in successfully' do
      user = create(:user)
      login_params = { email: 'user@email.com', password: '123456' }

      post('/api/auth/sign_in', params: login_params)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['data']['email']).to eq(user.email)
      expect(response.headers).to include('access-token')
      expect(response.headers).to include('client')
      expect(response.headers['token-type']).to include('Bearer')
    end

    it 'log in with user that has unconfirmed email' do
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.654.544-44', address: build(:address))
      login_params = { email: 'user@email.com', password: '123456' }

      post('/api/auth/sign_in', params: login_params)

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be false
      expect(json_response['errors'].first).to include ("A confirmation email was sent to your account at 'user@email.com'.")              
    end

    it 'with invalid data' do
      create(:user)
      login_params = { email: 'userABC@email.com', password: '1234563' }

      post('/api/auth/sign_in', params: login_params)

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be false
      expect(json_response['errors'].first).to include ("Invalid login credentials. Please try again.") 
    end
  end

  describe 'DELETE api/auth/sign_out' do
    it 'log out successfully' do
      user = create(:user)
      
      delete('/api/auth/sign_out', headers: user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      response_json = JSON.parse(response.body)
      expect(response_json["success"]).to be true
    end

    it 'log out without headers' do
      user = create(:user)

      delete('/api/auth/sign_out')

      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be false
      expect(json_response['errors'].first).to include ("User was not found or was not logged in.") 

    end
  end
end