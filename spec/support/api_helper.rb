module ApiHelper
  attr_reader :uid, :client, :access_token

  def request_sign_in(user)
    post api_v1_user_session_path, params: {
      email: user.email,
      password: user.password
    }
    @uid = response_header[:uid]
    @client = response_header[:client]
    @access_token = response_header[:"access-token"]
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
