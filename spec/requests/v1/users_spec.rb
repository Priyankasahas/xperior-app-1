require 'rails_helper'

RSpec.describe 'users endpoint' do
  context 'fetch all users' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    context 'given an authenticated request' do
      before do
        authenticated_get users_path
      end

      it 'should return a 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return the list of users' do
        expect(json_body).to eq('users' => [{ 'id' => user1.id,
                                              'email' => user1.email,
                                              'first_name' => user1.first_name,
                                              'last_name' => user1.last_name },
                                            { 'id' => user2.id,
                                              'email' => user2.email,
                                              'first_name' => user2.first_name,
                                              'last_name' => user2.last_name }])
      end
    end

    context 'given an unauthenticated request' do
      before do
        get users_path
      end

      it 'should return status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should return empty response' do
        expect(response.body).to eq http_access_denied
      end
    end
  end

  context 'fetch user details' do
    let(:user) { create(:user) }

    context 'given a valid user ID' do
      before do
        authenticated_get user_path(user.id)
      end

      it 'should return a 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return the user details' do
        expect(json_body).to eq('user' => { 'id' => user.id,
                                            'email' => user.email,
                                            'first_name' => user.first_name,
                                            'last_name' => user.last_name })
      end
    end

    context 'given invalid id' do
      let(:invalid_user_id) { '123' }

      it 'should return a 404 status code' do
        authenticated_get user_path(invalid_user_id)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'given an unauthenticated request' do
    let(:user) { create(:user) }

    before do
      get user_path(user.id)
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
