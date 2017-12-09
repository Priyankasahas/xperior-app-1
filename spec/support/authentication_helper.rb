module AuthenticationHelper
  def encoded_password
    ActionController::HttpAuthentication::Basic.encode_credentials(Rails.application.secrets.api_username, Rails.application.secrets.api_password)
  end

  def header_basic_auth
    {
      'HTTP_AUTHORIZATION' => encoded_password
    }
  end

  def authenticated_get(path, params = {}, headers = {})
    get path, params: params, headers: headers.merge(header_basic_auth)
  end

  def authenticated_get_json(path, params = {}, headers = {})
    authenticated_get(
      path, params,
      headers.merge(
        'HTTP_ACCEPT' => 'application/json',
        'CONTENT_TYPE' => 'application/json'
      )
    )
  end

  def authenticated_get_csv(path, params = {}, headers = {})
    authenticated_get(
      path, params,
      headers.merge(
        'HTTP_ACCEPT' => 'text/csv',
        'CONTENT_TYPE' => 'application/json'
      )
    )
  end

  def authenticated_post(path, params = {}, headers = {})
    post path,
         params: params,
         headers: headers.merge(header_basic_auth)
  end

  def authenticated_put(path, params = {}, headers = {})
    put path,
        params: params,
        headers: headers.merge(header_basic_auth)
  end

  def authenticated_delete(path, params = {}, headers = {})
    delete path,
           params: params,
           headers: headers.merge(header_basic_auth)
  end

  def http_access_denied
    "HTTP Basic: Access denied.\n"
  end
end
