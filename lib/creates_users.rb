class CreatesUsers
  Result = Struct.new(:success?, :errors, :user)

  def self.create!(attrs = {})
    user = User.new(
      first_name: attrs[:first_name],
      last_name: attrs[:last_name],
      email: attrs[:email],
      password: attrs[:password],
      password_confirmation: attrs[:password_confirmation]
    )

    user_created = user.save

    Result.new(user_created, user.errors.messages, user)
  end
end
