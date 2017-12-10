require 'securerandom'

class AuthenticatesUsers
  def self.authenticate(email, password)
    return nil unless email && password

    user = User.user_by_email(email)
    return unless user&.authenticate(password)

    token = SecureRandom.base64(12)
    user.authentication_token = token
    user.authentication_token_created_at = Time.now
    user.save!
    user
  end
end
