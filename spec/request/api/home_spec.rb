require 'rails_helper'

RSpec.describe 'Test Rspec', :type => :request do
  context 'Testing' do
    it 'Its working' do
      get('/api/v1/home')
      expect(response).to have_http_status(:ok)
    end
  end
end