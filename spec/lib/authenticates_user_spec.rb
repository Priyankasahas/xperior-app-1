require 'spec_helper'
require 'authenticates_users'

RSpec.describe AuthenticatesUsers do
  context '.authenticate' do
    let(:email) { 'pri@example.com' }
    let(:password) { '123' }
    let(:user) { double(:user, email: email, password: password) }
    let(:model) { class_double('User').as_stubbed_const }
    let(:secure_random) { class_double('SecureRandom').as_stubbed_const }

    context 'given valid credentials' do
      before do
        allow(model).to receive(:user_by_email).with(email).and_return(user)
        expect(secure_random).to receive(:base64).and_return('I4R8ThDqvbh1eDpY')
        allow(user).to receive(:authenticate).with(password).and_return(user)
      end

      it 'should return the user' do
        expect(model).to receive(:user_by_email).with(email)
        expect(user).to receive(:authenticate).with(password)
        expect(user).to receive(:authentication_token=).with('I4R8ThDqvbh1eDpY')
        expect(user).to receive(:authentication_token_created_at=)
        expect(user).to receive(:save!).and_return(true)
        expect(AuthenticatesUsers.authenticate(email, password)).to eq(user)
      end
    end

    context 'given invalid email' do
      before do
        allow(model).to receive(:user_by_email).with(email).and_return(nil)
      end

      it 'should return nil' do
        expect(model).to receive(:user_by_email).with(email)
        expect(AuthenticatesUsers.authenticate(email, password)).to eq nil
      end
    end

    context 'given invalid password' do
      before do
        allow(model).to receive(:user_by_email).with(email).and_return(user)
        allow(user).to receive(:authenticate).with(password).and_return(false)
      end

      it 'should return nil' do
        expect(user).to receive(:authenticate).with(password)
        expect(AuthenticatesUsers.authenticate(email, password)).to eq nil
      end
    end

    context 'given no credentials' do
      it 'should return nil' do
        expect(AuthenticatesUsers.authenticate(nil, nil)).to eq nil
      end
    end
  end
end
