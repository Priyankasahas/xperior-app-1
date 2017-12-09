require 'authenticates_users'

module V1
  class AuthenticationController < PrivateController
    def create
      user = AuthenticatesUsers.authenticate(params[:email], params[:password])
      if user.present?
        render json: user
      else
        head :not_found
      end
    end
  end
end
