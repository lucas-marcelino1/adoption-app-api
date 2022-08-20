require 'rails_helper'

RSpec.describe 'Adoption', :type => :request do
  context 'GET api/v1/adoptions' do
    it 'successfully' do
      adoption = create(:adoption)
      animal = Animal.create!(name: 'Alfredo', age: '1.0', specie: 'Dog', gender: 'Male', size: 'Large', user: adoption.user, status: Animal.statuses["in_adoption"])
      adoption_two = Adoption.create!(title: 'Guard dog', description: 'Perfect dog to protect your home and family.', user: adoption.user, animal: animal)

      get('/api/v1/adoptions', headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.first['title']).to eq('This cute cat needs a home')
      expect(json_response.first['description']).to eq("I've founded it on side of Beahaus street inside a box.")
      expect(json_response.first['animal']['gender']).to eq('Male')
      expect(json_response.first['animal']['specie']).to eq('Cat')
      expect(json_response.last['title']).to eq('Guard dog')
      expect(json_response.last['description']).to eq("Perfect dog to protect your home and family.")
      expect(json_response.last['animal']['gender']).to eq('Male')
      expect(json_response.last['animal']['specie']).to eq('Dog')
    end

    it 'and just in_adoption animals' do
      adoption = create(:adoption)
      animal = Animal.create!(name: 'Alfredo', age: '1.0', specie: 'Dog', gender: 'Male', size: 'Large', user: adoption.user)
      animal.adopted!
      adoption_two = Adoption.create!(title: 'Guard dog', description: 'Perfect dog to protect your home and family.', user: adoption.user, animal: animal)

      get('/api/v1/adoptions', headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response.first['title']).to eq('This cute cat needs a home')
      expect(json_response.first['description']).to eq("I've founded it on side of Beahaus street inside a box.")
      expect(json_response.first['animal']['gender']).to eq('Male')
      expect(json_response.first['animal']['specie']).to eq('Cat')  
    end

    it 'and none adoptions registred' do
      user = create(:user)

      get('/api/v1/adoptions', headers: user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('None adoptions registred yet.')
    end

    it 'without authentication headers and failed' do
      adoption = create(:adoption)
      animal = Animal.create!(name: 'Alfredo', age: '1.0', specie: 'Dog', gender: 'Male', size: 'Large', user: adoption.user)
      adoption_two = Adoption.create!(title: 'Guard dog', description: 'Perfect dog to protect your home and family.', user: adoption.user, animal: animal)
      
      get("/api/v1/adoptions")

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end

    it 'and something goes wrong' do
      adoption = create(:adoption)
      allow(Adoption).to receive(:all).and_raise(StandardError)

      get('/api/v1/adoptions', headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:internal_server_error)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['errors']['title']).to eq('Something went wrong.')
      expect(json_response['errors']['details']).to eq("Sorry, we encountered unexpected error.")
    end
  end

  context 'GET api/v1/adoptions/adoption_id' do
    it 'successfully' do
      adoption = create(:adoption)
      animal = Animal.create!(name: 'Alfredo', age: '1.0', specie: 'Dog', gender: 'Male', size: 'Large', user: adoption.user)
      adoption_two = Adoption.create!(title: 'Guard dog', description: 'Perfect dog to protect your home and family.', user: adoption.user, animal: animal)
      
      get("/api/v1/adoptions/#{adoption.id}", headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq('This cute cat needs a home')
      expect(json_response['description']).to eq("I've founded it on side of Beahaus street inside a box.")
      expect(json_response['location']).to eq("Blumenau || Santa Catarina")
      expect(json_response['user']).to eq("User Name")
      expect(json_response['animal']['name']).to eq('Tunico')
      expect(json_response['animal']['age']).to eq(0.11)
      expect(json_response['animal']['gender']).to eq('Male')
      expect(json_response['animal']['specie']).to eq('Cat')
      expect(json_response['animal']['size']).to eq('Small')
    end

    it 'without authentication headers and failed' do
      adoption = create(:adoption)
    
      get("/api/v1/adoptions/#{adoption.id}")

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end
  end

  context 'POST api/v1/adoptions/adoption_id/adopt' do
    it 'successfully' do
      adoption = create(:adoption)
      user = User.create!(name: 'User Name 2', email: 'user2@email.com', password: '123456', registration_number: '112.221.222-47', confirmed_at: Time.zone.now, address: build(:address))
      adopt_params = { adoption_id: adoption.id, user_email: "user2@email.com" }

      post("/api/v1/adoptions/#{adoption.id}/adopt", headers: adoption.user.create_new_auth_token, params: adopt_params)
      
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Animal adopted successfully.')
    end

    it 'and something went wrong' do
      adoption = create(:adoption)
      user = User.create!(name: 'User Name 2', email: 'user2@email.com', password: '123456', registration_number: '112.221.222-47', confirmed_at: Time.zone.now, address: build(:address))
      adopt_params = { adoption_id: adoption.id, user_email: "user2@email.com" }

      post("/api/v1/adoptions/#{adoption.id}/adopt", headers: adoption.user.create_new_auth_token)
      
      expect(response).to have_http_status(:internal_server_error)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['errors']['title']).to eq('Something went wrong.')
      expect(json_response['errors']['details']).to eq("Sorry, we encountered unexpected error.")
    end
  end

  context 'POST api/v1/adoptions' do
    it 'successfully' do
      animal = create(:animal)
      adoption_params = {adoption: {title: 'This cute cat needs a home', description: "I've founded it on side of Beahaus street inside a box.", animal_id: "#{animal.id}", user_id: "#{animal.user.id}"}}

      post('/api/v1/adoptions', headers: animal.user.create_new_auth_token, params: adoption_params)

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      animal.reload
      expect(animal.in_adoption?).to be true
      expect(json_response['message']).to eq('Adoption created successfully.')
      expect(json_response['adoption']['title']).to eq("This cute cat needs a home")
      expect(json_response['adoption']['animal']).to eq('Tunico')
      expect(json_response['adoption']['user']).to eq('User Name')
    end

    it 'with invalid data and failed' do
      user = create(:user)
      adoption_params = {adoption: {title: 'This cute cat needs a homeAAAAAAAAAAAAAAAAAAAAA',
                         description: "I've founded it on side of Beahaus street inside a box.",
                         animal_id: 37478, user_id: 488147}}

      post('/api/v1/adoptions', headers: user.create_new_auth_token, params: adoption_params)

      expect(response).to have_http_status(:precondition_failed)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Adoption was not created!')
      expect(json_response['errors']).to include("Animal must exist")
      expect(json_response['errors']).to include('User must exist')
      expect(json_response['errors']).to include("Title is too long (maximum is 40 characters)")
    end
  end

  context 'DELETE api/v1/adoption/adoption_id' do
    it 'successfully' do
      adoption = create(:adoption)

      delete("/api/v1/adoptions/#{adoption.id}", headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq('Adoption deleted successfully!')
    end

    it 'without authentication headers and failed' do
      adoption = create(:adoption)

      delete("/api/v1/adoptions/#{adoption.id}")

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end

    it 'failed cuz try to delete adoption from another user' do
      user = create(:user)
      adoption = create(:adoption, user: user)
      user2 = User.create!(name: 'User Name 2', email: 'user2@email.com', password: '123456', registration_number: '112.584.544-44', address: build(:address))
      delete("/api/v1/adoptions/#{adoption.id}", headers: user2.create_new_auth_token)

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]['title']).to eq('User not authorized.')
      expect(json_response["errors"]["details"]).to eq('You have no authorization to do this.')
    end
  end
end
