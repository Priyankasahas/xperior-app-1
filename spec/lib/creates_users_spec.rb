require 'spec_helper'
require 'creates_users'

RSpec.describe CreatesUsers do
  context 'create!' do
    let(:first_name) { 'Priyanka' }
    let(:last_name) { 'Patel' }
    let(:email) { 'priyanka.patel@email.com' }

    let(:user_model) { class_double('User').as_stubbed_const }
    let(:user) { double(:user) }

    before do
      allow(user_model).to receive(:new) { user }
    end

    let(:attrs) do
      { first_name: first_name,
        last_name: last_name,
        email: email,
        password: 'Testing123#',
        password_confirmation: 'Testing123#' }
    end

    subject { CreatesUsers.create!(attrs) }

    context 'given valid user data' do
      before do
        expect(user).to receive(:save) { true }
        expect(user).to receive(:errors) { double(messages: []) }
      end

      it 'should indicate a successful creation' do
        expect(subject).to be_success
      end

      it 'should return no errors' do
        expect(subject.errors).not_to be_present
      end

      it 'should return access to the created user' do
        expect(subject.user).to eq user
      end
    end

    context 'given invalid user data' do
      let(:message) { 'content' }

      before do
        expect(user).to receive(:save) { false }
        expect(user).to receive(:errors) { double(messages: message) }
      end

      it 'should indicate an unsuccessful creation' do
        expect(subject).not_to be_success
      end

      it 'should return errors' do
        expect(subject.errors).to be_present
      end

      it 'should return access to the errored user' do
        expect(subject.user).to eq user
      end
    end
  end
end
