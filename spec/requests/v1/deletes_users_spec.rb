require 'rails_helper'

RSpec.describe 'delete user endpoint' do
  let(:first_name) { 'John' }
  let(:last_name) { 'Smith' }
  let(:email) { 'john.smith@email.com' }

  context 'given valid user data' do
    before do
      user = create(:user, email: email, first_name: first_name, last_name: last_name)
      authenticated_delete user_path(user.id)
    end

    it 'should delete user' do
      expect(User.user_by_email(email)).to be_nil
    end
  end

  context 'given invalid user data' do
    before do
      authenticated_delete user_path(11111)
    end

    it 'should return not found' do
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'given an unauthenticated request' do
    before do
      user = create(:user)
      delete user_path(user.id)
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
