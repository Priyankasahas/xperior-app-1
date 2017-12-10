require 'authenticates_users'

module V1
  class AuthenticationController < PrivateController
    def create
      render json: 'Require User Credentials', status: :not_found and return unless params[:email] && params[:password]

      user = AuthenticatesUsers.authenticate(params[:email], params[:password])
      if user.present?
        render json: { token: user.authentication_token }
      else
        head :not_found
      end
    end
  end
end
