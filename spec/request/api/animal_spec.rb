require 'rails_helper'

RSpec.describe 'Animals', :type => :request do
  context 'GET api/v1/animals' do
    it 'successfully' do
      Animal.create!(name:'Tunico', age: '0.11', specie: 'Cat', gender: 'Male', size: 'Small')

      get('/api/v1/animals')

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.first['name']).to eq("Tunico")
      expect(json_response.first['age']).to eq(0.11)
      expect(json_response.first['specie']).to eq("Cat")
      expect(json_response.first['gender']).to eq("Male")
      expect(json_response.first['size']).to eq("Small")
    end
  end
end