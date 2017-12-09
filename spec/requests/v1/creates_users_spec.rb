require 'rails_helper'

RSpec.describe 'create user endpoint' do
  let(:first_name) { 'Pri' }
  let(:last_name) { 'Sahas' }
  let(:email) { 'pri.sahas@email.com' }
  let(:password) { 'Testing123#' }

  context 'given valid user data' do
    before do
      authenticated_post users_path, user: { first_name: first_name,
                                             last_name: last_name,
                                             email: email,
                                             password: password,
                                             password_confirmation: password }
    end

    it 'should return a created status' do
      expect(response).to have_http_status(:created)
    end

    context 'created user' do
      subject { User.user_by_email(email) }

      it 'should have the specified first name' do
        expect(subject.first_name).to eq first_name
      end

      it 'should have specified last name' do
        expect(subject.last_name).to eq last_name
      end

      it 'should have specified email' do
        expect(subject.email).to eq email
      end
    end
  end

  context 'given invalid user data' do
    context 'with first_name, last_name and email being nil' do
      before do
        authenticated_post users_path, user: { first_name: nil,
                                               last_name: nil,
                                               email: nil,
                                               password: password,
                                               password_confirmation: password }
      end

      it 'should indicate a bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should include the missing handler error' do
        expect(json_body).to eq 'first_name' => ["can't be blank"],
                                'last_name' => ["can't be blank"],
                                'email' => ["can't be blank", 'is invalid']
      end
    end

    context 'with invalid email address' do
      before do
        authenticated_post users_path, user: { first_name: first_name,
                                               last_name: last_name,
                                               email: 'invalid_email.com',
                                               password: password,
                                               password_confirmation: password }
      end

      it 'should indicate a bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should include the invalid email error' do
        expect(json_body).to eq 'email' => ['is invalid']
      end
    end
  end

  context 'given an unauthenticated request' do
    before do
      post users_path
    end

    it 'should return status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should return empty response' do
      expect(response.body).to eq http_access_denied
    end
  end
end
