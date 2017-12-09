class AuthenticatesUsers
  def self.authenticate(email, password)
    return nil unless email && password

    user = User.user_by_email(email)
    user if user&.authenticate(password)
  end
end
