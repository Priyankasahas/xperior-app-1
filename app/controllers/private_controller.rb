class PrivateController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :valid_credentials_required

  protected

  def valid_credentials_required
    username = Rails.application.secrets.api_username
    password = Rails.application.secrets.api_password

    authenticate_or_request_with_http_basic do |u, p|
      u == username && p == password
    end
  end
end
