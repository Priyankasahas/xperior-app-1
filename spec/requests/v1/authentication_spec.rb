require 'rails_helper'

RSpec.describe 'user authentication endpoint' do
  let(:password) { '1abQwerty!' }
  let(:user) { create(:user, password: password, password_confirmation: password) }

  context 'given valid credentials' do
    before do
      authenticated_post authentication_index_path, email: user.email, password: password
    end

    it 'should return a 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return the user auth token' do
      expect(response.body).to be_kind_of(String)
    end
  end

  context 'given invalid password' do
    it 'should return a 404 status code' do
      authenticated_post authentication_index_path, email: user.email, password: 'foo'
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'given invalid email' do
    it 'should return a 404 status code' do
      authenticated_post authentication_index_path, email: 'invalid@email.com', password: 'foo'
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'given no credentials' do
    it 'should return a 404 status code' do
      authenticated_post authentication_index_path, email: nil, password: nil
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'given an unauthenticated request' do
    before do
      post authentication_index_path, params: { email: user.email, password: password }
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
