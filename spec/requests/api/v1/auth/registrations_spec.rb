require 'rails_helper'

RSpec.describe "Registrations", type: :request do

  describe "Create User" do
    let(:params_hash) { attributes_for(:user) }

    it "create new user successfully" do
      # request
      post api_v1_user_registration_path, params: params_hash
      expect(response).to have_http_status 200

      # added user
      user = User.order(updated_at: :desc).first
      expect(user.email).to eq params_hash[:email]
    end

    it "fail password confirmation: 422 Unprocessable Entity" do
      params_hash.merge!(
        password: "password",
        password_confirmation: "xxx"
      )
      post api_v1_user_registration_path, params: params_hash
      expect(response).to have_http_status 422
    end
  end

  describe "Update User" do
    # PATCH  /api/v1/auth
    it "update an user"
    it "can't update user unless signed in"
  end

  describe "Delete User" do
    # DELETE   /api/v1/auth
    it "delete an user"
    it "can't delete user unless signed in"
  end

  describe "Sign in" do
    let(:user) { create(:user, password: "password") }

    it "sign in successfully" do
      post api_v1_user_session_path, params: {
        email: user.email,
        password: user.password
      }
      expect(response).to have_http_status 200
    end

    it "sign in failed: 401 Unauthorized" do
      post api_v1_user_session_path, params: {
        email: user.email,
        password: "xxx"
      }
      expect(response).to have_http_status 401
    end
  end

  describe "Sign out" do
    let(:user) { create(:user, password: "password") }

    it "sign out" do
      # sign in
      post api_v1_user_session_path, params: {
        email: user.email,
        password: user.password
      }
      expect(response).to have_http_status 200

      # sign out
      uid = response.header["uid"]
      client = response.header["client"]
      token = response.header["access-token"]

      delete destroy_api_v1_user_session_path, params: {
        "uid": uid,
        "client": client,
        "access-token": token,
      }
      expect(response).to have_http_status 200
    end
  end
end
