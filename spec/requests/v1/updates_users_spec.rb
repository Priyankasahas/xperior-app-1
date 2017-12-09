require 'rails_helper'

RSpec.describe 'update user endpoint' do
  let(:first_name) { 'Pri' }
  let(:last_name) { 'Sahas' }
  let(:email) { 'pri.sahas@email.com' }

  context 'given valid user data' do
    before do
      user = create(:user, email: email, first_name: first_name, last_name: last_name)
      authenticated_put user_path(user.id), user: { email: 'some+email@test.com.au' }
    end

    it 'should update user' do
      expect(User.first.email).to eq('some+email@test.com.au')
    end
  end

  context 'given invalid user data' do
    before do
      authenticated_put user_path(11111), user: { email: 'some+email@test.com.au' }
    end

    it 'should return not found' do
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'given an unauthenticated request' do
    before do
      user = create(:user)
      put user_path(user.id)
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
