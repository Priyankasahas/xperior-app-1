class UpdatesUsers
  Result = Struct.new(:success?, :errors, :user)

  def self.update!(user_id, attrs = {})
    user = User.user_by_id(user_id)

    return Result.new(false, errors: ['User is not found']) unless user.present?

    Result.new(user.update_attributes(attrs), user.try(:errors).try(:messages),
               user)
  end
end
