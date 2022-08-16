require 'rails_helper'

RSpec.describe 'User', :type => :request do
  describe 'POST api/auth' do
    it 'sucessfully' do
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
  end
end