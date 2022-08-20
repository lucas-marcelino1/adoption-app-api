require 'rails_helper'

RSpec.describe 'Animal', :type => :request do
  context 'GET api/v1/animals' do
    it 'successfully' do
      user = create(:user)
      create(:animal, user: user)

      get('/api/v1/animals', headers: user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.first['name']).to eq("Tunico")
      expect(json_response.first['age']).to eq(0.11)
      expect(json_response.first['specie']).to eq("Cat")
      expect(json_response.first['gender']).to eq("Male")
      expect(json_response.first['size']).to eq("Small")
      expect(json_response.first['user']['name']).to eq('User Name')
    end

    it 'without authentication headers and failed' do
      user = create(:user)
      animal = create(:animal, user: user)

      get("/api/v1/animals")

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end

    it 'and something goes wrong' do
      user = create(:user)
      create(:animal, user: user)
      allow(Animal).to receive(:all).and_raise(StandardError)

      get('/api/v1/animals', headers: user.create_new_auth_token)

      expect(response).to have_http_status(:internal_server_error)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['errors']['title']).to eq('Something went wrong.')
      expect(json_response['errors']['details']).to eq("Sorry, we encountered unexpected error.")
    end
  end

  context 'POST api/v1/animals' do
    it 'successfully' do
      user = create(:user)
      animal_params = {animal: {name:'Tunico', age: '0.11', specie: 'Cat', gender: 'Male', size: 'Small', user_id: user.id }}

      post('/api/v1/animals', params: animal_params, headers: user.create_new_auth_token)

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Animal created successfully.")
      expect(json_response['name']).to eq('Tunico')
      expect(json_response['user_name']).to eq('User Name')
    end

    it 'with invalid data and was not created' do
      user = create(:user)
      animal_params = {animal: {name:'', age: '0.11', specie: '', gender: 'Male', size: 'Small', user_id: 178 }}

      post('/api/v1/animals', params: animal_params, headers: user.create_new_auth_token)

      expect(response).to have_http_status(:precondition_failed)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Animal was not created!")
      expect(json_response['errors']).to include("Name can't be blank")
      expect(json_response['errors']).to include("User must exist")
      expect(json_response['errors']).to include("Specie can't be blank")
    end

    it 'without authentication headers and failed' do
      user = create(:user)
      animal_params = {animal: {name:'', age: '0.11', specie: '', gender: 'Male', size: 'Small', user_id: 178 }}

      post('/api/v1/animals', params: animal_params)

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end

    it 'and something goes wrong' do
      user = create(:user)
      animal_params = {animal: {name:'Tunico', age: '0.11', specie: 'Cat', gender: 'Male', size: 'Small', user_id: user.id }}
      allow(Animal).to receive(:new).and_raise(StandardError)

      post('/api/v1/animals', params: animal_params, headers: user.create_new_auth_token)

      expect(response).to have_http_status(:internal_server_error)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['errors']['title']).to eq('Something went wrong.')
      expect(json_response['errors']['details']).to eq("Sorry, we encountered unexpected error.")
    end
  end

  context 'UPDATE api/v1/animals/animal_id' do
    it 'successfully' do
      user = create(:user)
      animal = create(:animal, user: user)
      animal_params = {animal: {name:'Clementina', age: '1.1', specie: 'Dog', gender: 'Female', size: 'Medium' }}

      patch("/api/v1/animals/#{animal.id}", headers: user.create_new_auth_token, params: animal_params)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq('Animal update successfully.')
      expect(json_response["animal"]["name"]).to eq('Clementina')
      expect(json_response["animal"]["age"]).to eq(1.1)
      expect(json_response["animal"]["specie"]).to eq('Dog')
      expect(json_response["animal"]["gender"]).to eq('Female')
      expect(json_response["animal"]["size"]).to eq('Medium')
    end

    it 'with invalid data and was not updated' do
      user = create(:user)
      animal = create(:animal, user: user)
      animal_params = {animal: {name:'Clementina', age: '-1.1', specie: 'Dog', gender: 'Ronaldo', size: 'Big' }}

      patch("/api/v1/animals/#{animal.id}", headers: user.create_new_auth_token, params: animal_params)

      expect(response).to have_http_status(:precondition_failed)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq('Animal was not update!')
      expect(json_response["errors"]).to include("Age must be greater than 0")
      expect(json_response["errors"]).to include("Size Big is not a valid size")
      expect(json_response["errors"]).to include("Gender Ronaldo is not a valid gender")
    end

    it 'without authentication headers and failed' do
      user = create(:user)
      animal = create(:animal, user: user)
      animal_params = {animal: {name:'Clementina', age: '1.1', specie: 'Dog', gender: 'Female', size: 'Medium' }}

      patch("/api/v1/animals/#{animal.id}", params: animal_params)

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end

    it 'failed because try to update an animal from another user' do
      user = create(:user)
      animal = create(:animal, user: user)
      user2 = User.create!(name: 'User Name 2', email: 'user2@email.com', password: '123456', registration_number: '112.554.544-44', address: build(:address))
      animal_params = {animal: {name:'Clementina', age: '1.1', specie: 'Dog', gender: 'Female', size: 'Medium' }}

      patch("/api/v1/animals/#{animal.id}", headers: user2.create_new_auth_token, params: animal_params)

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]['title']).to eq('User not authorized.')
      expect(json_response["errors"]["details"]).to eq('You have no authorization to do this.')
      animal.reload
      expect(animal.name).to eq('Tunico')
      expect(animal.age).to eq(0.11)
      expect(animal.specie).to eq('Cat')
      expect(animal.gender).to eq('Male')
      expect(animal.size).to eq('Small')
    end
  end

  context 'DELETE /api/v1/animals/animal_id' do
    it 'successfully' do
      animal = create(:animal)

      delete("/api/v1/animals/#{animal.id}", headers: animal.user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq('Animal deleted successfully.')
    end

    it 'without authentication headers and failed' do
      animal = create(:animal)

      delete("/api/v1/animals/#{animal.id}")

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end

    it 'try to delete animal from another user' do
      user = create(:user)
      animal = create(:animal, user: user)
      user2 = User.create!(name: 'User Name 2', email: 'user2@email.com', password: '123456', registration_number: '112.584.544-44', address: build(:address))
      delete("/api/v1/animals/#{animal.id}", headers: user2.create_new_auth_token)

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]['title']).to eq('User not authorized.')
      expect(json_response["errors"]["details"]).to eq('You have no authorization to do this.')
    end
  end
end