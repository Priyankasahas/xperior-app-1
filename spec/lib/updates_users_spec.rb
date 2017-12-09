require 'spec_helper'
require 'updates_users'

RSpec.describe UpdatesUsers do
  context 'update!' do
    let(:user_id) { 1 }
    let(:attrs) do
      { first_name: 'John',
        last_name: 'Smith',
        email: ' john.smith@test.com' }
    end

    let(:user_model) { class_double('User').as_stubbed_const }
    let(:user) { double(:user) }

    subject { UpdatesUsers.update!(user_id, attrs) }

    context 'given invalid user data' do
      before do
        expect(user_model).to receive(:user_by_id).and_return(user)
        expect(user).to receive(:update_attributes).with(attrs).and_return(false)
      end

      it 'should indicate an unsuccessful update' do
        expect(subject.success?).to be false
      end

      it 'should return access to the errored user' do
        expect(subject.user).to eq user
      end
    end

    context 'given valid user data' do
      before do
        expect(user_model).to receive(:user_by_id).and_return(user)
        expect(user).to receive(:update_attributes).with(attrs).and_return(true)
      end

      it 'should indicate a successfull update' do
        expect(subject.success?).to be true
      end

      it 'should return access to the updated user' do
        expect(subject.user).to eq user
      end
    end
  end
end
