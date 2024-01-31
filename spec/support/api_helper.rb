module ApiHelper
  attr_reader :uid, :client, :access_token, :auth_headers

  def request_sign_in(user_params)
    params = {}

    if user_params.class == User
      params.merge!(email: user.email, password: user.password)
    else
      params.merge!(user_params)
    end

    post api_v1_user_session_path, params: params
    @uid = response_header[:uid]
    @client = response_header[:client]
    @access_token = response_header[:"access-token"]
    @auth_headers = {
      "uid": uid,
      "client": client,
      "access-token": access_token,
    }
  end

  def request_user_update(params)
    patch api_v1_user_registration_path, headers: auth_headers, params: params
  end

  def request_password_update(params)
    patch api_v1_user_password_path, headers: auth_headers, params: params
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
