require 'rails_helper'

RSpec.describe User do
  context 'validations' do
    subject { create(:user) }

    context 'email validations' do
      let(:another_user_email) { 'john.smith@abc.com' }
      let!(:another_user) { create(:user, email: another_user_email) }
      let(:user) { create(:user) }

      subject do
        user.email = new_email
        user
      end

      context 'invalid' do
        context 'blank email' do
          [nil, ''].each do |new_email|
            let(:new_email) { new_email }

            it 'should be invalid and have errors messages' do
              expect(subject.valid?).to be false
              expect(subject.errors.full_messages).to include "Email can't be blank"
            end
          end
        end

        context 'email already exists' do
          let(:new_email) { another_user_email }

          it 'should be invalid and have errors messages' do
            expect(subject.valid?).to be false
            expect(subject.errors.full_messages).to include "Email #{another_user_email} has already been taken"
          end
        end

        context 'email regex is invalid' do
          let(:new_email) { 'test.com' }

          it 'should be invalid and have errors messages' do
            expect(subject.valid?).to be false
            expect(subject.errors.full_messages).to include 'Email is invalid'
          end
        end
      end
    end

    context 'password validations' do
      let(:user) { create(:user) }

      subject do
        user.password = password
        user.password_confirmation = password
        user
      end

      context 'invalid' do
        ['', 'abQwerty!'].each do |password|
          let(:password) { password }

          it 'should be invalid and have errors messages' do
            expect(subject.valid?).to be false
            expect(subject.errors.full_messages).to include 'Password must be at least 8 characters and contain a number'
          end
        end
      end

      context 'valid' do
        ['12345***', '1abQwerty!'].each do |password|
          let(:password) { password }

          it 'should be valid' do
            expect(subject.valid?).to be true
          end
        end
      end
    end

    context 'password confirmation validations' do
      let(:user) { create(:user) }

      subject do
        user.password = password
        user.password_confirmation = password_confirmation
        user
      end

      context 'invalid' do
        let(:password) { '1abQwerty!' }

        context 'cannot be empty' do
          let(:password_confirmation) { '' }

          it 'should be invalid and have errors messages' do
            expect(subject.valid?).to be false
            expect(subject.errors.full_messages).to include "Password confirmation can't be blank"
          end
        end

        context 'must match with the password' do
          let(:password_confirmation) { password + '*' }

          it 'should be invalid and have errors messages' do
            expect(subject.valid?).to be false
            expect(subject.errors.full_messages).to include "Password confirmation doesn't match Password"
          end
        end
      end

      context 'valid' do
        let(:password) { '1abQwerty!' }
        let(:password_confirmation) { password }

        it 'should be valid' do
          expect(subject.valid?).to be true
        end
      end
    end
  end

  context '.user_by_email' do
    context 'when the user exists' do
      it 'should return the user' do
        user = create(:user)
        expect(User.user_by_email(user.email)).to eq user
      end
    end

    context 'when the user does not exist' do
      it 'should return nil' do
        expect(User.user_by_email('bob@example.com')).to eq nil
      end
    end
  end

  context '.user_by_id' do
    context 'when the user exists' do
      it 'should return the user' do
        user = create(:user)
        expect(User.user_by_id(user.id)).to eq user
      end
    end

    context 'when the user does not exist' do
      it 'should return nil' do
        expect(User.user_by_id(1)).to eq nil
      end
    end
  end
end
