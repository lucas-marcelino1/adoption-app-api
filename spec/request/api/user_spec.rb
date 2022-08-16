require 'rails_helper'

RSpec.describe 'User', :type => :request do
  describe 'POST api/auth' do
    it 'sucessfully' do
      user_params = {email: "new_user@email.com", name: "New User", registration_number: "111.222.333-45",
                password: "123456", password_confirmation: "123456"}
      post('/api/auth', params: user_params)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
    end
  end
end