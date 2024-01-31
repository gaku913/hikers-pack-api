module ApiHelper
  attr_reader :uid, :client, :access_token, :auth_headers

  # Sign in
  def request_sign_in(user_params)
    params = {}

    if user_params.class == User
      # Case: ActiveRecord
      params.merge!(email: user.email, password: user.password)
    else
      # Case: Hash
      params.merge!(user_params)
    end

    post api_v1_user_session_path, params: params
    @uid = response_header[:uid]
    @client = response_header[:client]
    @access_token = response_header[:"access-token"]
    set_auth_headers({
      "uid": uid,
      "client": client,
      "access-token": access_token,
    })
  end

  def set_auth_headers(kwargs)
    @auth_headers = kwargs
  end

  # Sign out
  def request_sign_out
    delete destroy_api_v1_user_session_path, headers: auth_headers
  end

  # User#Update
  def request_user_update(params)
    patch api_v1_user_registration_path, headers: auth_headers, params: params
  end

  # Password#Update
  def request_password_update(params)
    patch api_v1_user_password_path, headers: auth_headers, params: params
  end

  # User#Destroy
  def request_user_destroy
    delete api_v1_user_registration_path, headers: auth_headers
  end

  def response_header
    response.header.transform_keys(&:to_sym)
  end

  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end

  def response_data
    response_body[:data]
  end

end
