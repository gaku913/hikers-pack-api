require 'rails_helper'

RSpec.describe "Registrations", type: :request do

  describe "Create User" do
    let(:params_hash) { attributes_for(:user) }

    it "create new user successfully" do
      # create request
      post api_v1_user_registration_path, params: params_hash
      expect(response).to have_http_status 200

      # check added user
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
    let(:user) { create(:user,
      name: "test",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
    ) }

    it "update user name" do
      request_sign_in user
      request_user_update(name: "Taro")
      user.reload
      expect(user.name).to eq "Taro"
    end

    it "update user email" do
      request_sign_in user
      request_user_update(email: "xxx@example.com")
      user.reload
      expect(user.email).to eq "xxx@example.com"
    end

    it "can't update user unless signed in" do
      request_user_update(name: "Taro")
      expect(response).to have_http_status 404
    end

    it "update password" do
      request_sign_in user
      request_password_update(
        password: "new password",
        password_confirmation: "new password",
      )
      # sign in with new password
      request_sign_in(email: user.email, password: "new password")
      expect(response).to have_http_status 200
    end

    it "can't update password unless signed in :401 Unauthorized" do
      request_password_update(
        password: "new password",
        password_confirmation: "new password",
      )
      expect(response).to have_http_status 401
    end
  end

  describe "Delete User" do
    # DELETE   /api/v1/auth
    it "delete an user"
    it "can't delete user unless signed in"
  end

  describe "Sign in" do
    let(:user) { create(:user, password: "password") }

    it "sign in successfully" do
      request_sign_in user
      expect(response).to have_http_status 200
    end

    it "sign in failed: 401 Unauthorized" do
      user.password = "xxx" # set wrong password
      request_sign_in user
      expect(response).to have_http_status 401
    end
  end

  describe "Sign out" do
    let(:user) { create(:user) }

    it "sign out" do
      # sign in
      request_sign_in user

      # sign out
      delete destroy_api_v1_user_session_path, params: {
        "uid": uid,
        "client": client,
        "access-token": access_token,
      }
      expect(response).to have_http_status 200
    end
  end
end
