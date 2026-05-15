require 'rails_helper'

RSpec.describe User, type: :model do

  # 1. DATABASE AUTHENTICATABLE
  describe 'DatabaseAuthenticatable' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a malformed email' do
      user = build(:user, email: 'not-an-email')
      expect(user).not_to be_valid
    end

    it 'is invalid with a duplicate email' do
      create(:user, email: 'dup@example.com')
      user = build(:user, email: 'dup@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid without a password' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'stores an encrypted password instead of plain text' do
      user = create(:user, password: 'Password1!')
      expect(user.encrypted_password).not_to eq('Password1!')
      expect(user.encrypted_password).not_to be_blank
    end

    it 'authenticates with the correct password' do
      user = create(:user, password: 'Password1!')
      expect(user.valid_password?('Password1!')).to be true
    end

    it 'does not authenticate with the wrong password' do
      user = create(:user, password: 'Password1!')
      expect(user.valid_password?('WrongPass!')).to be false
    end
  end

  # 2. VALIDATABLE
  describe 'Validatable' do
    it 'is invalid when password is too short' do
      # Devise default minimum is 6 characters
      user = build(:user, password: 'ab1!', password_confirmation: 'ab1!')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it 'is invalid when password and confirmation do not match' do
      user = build(:user, password: 'Password1!', password_confirmation: 'Different1!')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to be_present
    end

    it 'is invalid with an email missing a domain' do
      user = build(:user, email: 'user@')
      expect(user).not_to be_valid
    end
  end

  # 3. REMEMBERABLE
  describe 'Rememberable' do
    it 'sets remember_created_at when remembering a user' do
      user = create(:user)
      expect { user.remember_me! }.to change { user.remember_created_at }.from(nil)
    end

    it 'clears remember_created_at when forgetting a user' do
      user = create(:user, :remembered)   # trait: remember_created_at set
      expect { user.forget_me! }.to change { user.remember_created_at }.to(nil)
    end

    it 'has nil remember_created_at by default' do
      user = build(:user)
      expect(user.remember_created_at).to be_nil
    end
  end

  # 4. TRACKABLE
  describe 'Trackable' do
    it 'starts with a sign_in_count of 0' do
      user = build(:user)
      expect(user.sign_in_count).to eq(0)
    end

    it 'increments sign_in_count on each sign in' do
      user = create(:user)
      # Simulate two sign-ins
      2.times { user.update_tracked_fields!(double('request', remote_ip: '127.0.0.1')) }
      expect(user.sign_in_count).to eq(2)
    end

    it 'records current_sign_in_at on sign in' do
      user = create(:user)
      user.update_tracked_fields!(double('request', remote_ip: '127.0.0.1'))
      expect(user.current_sign_in_at).to be_present
    end

    it 'moves current_sign_in_at to last_sign_in_at on subsequent sign in' do
      user    = create(:user)
      request = double('request', remote_ip: '127.0.0.1')
      user.update_tracked_fields!(request)
      first_sign_in = user.current_sign_in_at

      travel 1.minute do
        user.update_tracked_fields!(request)
      end

      expect(user.last_sign_in_at).to be_within(1.second).of(first_sign_in)
    end

    it 'records the IP address on sign in' do
      user = create(:user)
      user.update_tracked_fields!(double('request', remote_ip: '10.0.0.1'))
      expect(user.current_sign_in_ip).to eq('10.0.0.1')
    end

    it 'moves current IP to last IP on subsequent sign in' do
      user = create(:user)
      user.update_tracked_fields!(double('request', remote_ip: '10.0.0.1'))
      user.update_tracked_fields!(double('request', remote_ip: '10.0.0.2'))
      expect(user.last_sign_in_ip).to eq('10.0.0.1')
      expect(user.current_sign_in_ip).to eq('10.0.0.2')
    end

    it 'has nil tracking fields before first sign in' do
      user = build(:user)
      expect(user.current_sign_in_at).to be_nil
      expect(user.last_sign_in_at).to be_nil
      expect(user.current_sign_in_ip).to be_nil
      expect(user.last_sign_in_ip).to be_nil
    end
  end

  # 5. LOCKABLE
  describe 'Lockable' do
    it 'is not locked by default' do
      user = build(:user)
      expect(user.access_locked?).to be false
    end

    it 'locks the account after too many failed attempts' do
      user = create(:user)
      # Devise default is 5 failed attempts
      Devise.maximum_attempts.times { user.valid_for_authentication? { false } }
      expect(user.access_locked?).to be true
    end

    it 'sets locked_at when the account is locked' do
      user = create(:user, :locked)  # trait: locked_at and failed_attempts set
      expect(user.locked_at).to be_present
    end

    it 'unlocks the account via unlock_access!' do
      user = create(:user, :locked)
      user.unlock_access!
      expect(user.access_locked?).to be false
      expect(user.locked_at).to be_nil
      expect(user.failed_attempts).to eq(0)
    end

    it 'generates an unlock token when locking' do
      user = create(:user)
      Devise.maximum_attempts.times { user.valid_for_authentication? { false } }
      expect(user.unlock_token).to be_present
    end
  end

  # 6. TIMEOUTABLE
  describe 'Timeoutable' do
    it 'has a positive timeout_in value' do
      user = build(:user)
      expect(user.timeout_in).to be > 0
    end

    it 'reports session as timed out when last request exceeds timeout' do
      user         = build(:user)
      last_request = (user.timeout_in + 1.minute).ago
      expect(user.timedout?(last_request)).to be true
    end

    it 'reports session as active when last request is within timeout' do
      user         = build(:user)
      last_request = (user.timeout_in - 1.minute).ago
      expect(user.timedout?(last_request)).to be false
    end

    it 'reports session as timed out when last_request_at is nil' do
      user = build(:user)
      expect(user.timedout?(nil)).to be nil
    end
  end
end