require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "access to User data" do
    let(:user) { create(:user) }

    before do
      request_sign_in user
    end

    it "get user data successfully" do
      get api_v1_auth_sessions_path, params: {
        "uid": uid,
        "client": client,
        "access-token": access_token,
      }
      expect(response).to have_http_status 200

      response_data = JSON.parse(response.body, symbolize_names: true)
      expect(response_data).to include(name: user.name)
    end

    it "fail if there is no access token" do
      get api_v1_auth_sessions_path, params: {
        "uid": uid,
        "client": client,
        "access-token": "",
      }
      expect(response).to have_http_status 401
    end

    it "fail if there is no client" do
      get api_v1_auth_sessions_path, params: {
        "uid": uid,
        "client": "",
        "access-token": access_token,
      }
      expect(response).to have_http_status 401
    end
  end
end
