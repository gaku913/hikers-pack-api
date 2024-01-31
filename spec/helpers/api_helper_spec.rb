require 'rails_helper'

RSpec.describe ApiHelper, type: :request do
  let(:user) { create(:user) }

  before do
    request_sign_in user
  end

  # request_sign_in
  it "request sign in" do
    expect(response).to have_http_status 200
    expect(uid).to eq user.email
    expect(client).not_to be nil
    expect(access_token).not_to be nil
  end

  # request_user_update
  it "request update user data" do
    request_sign_in user
    request_user_update(name: "Taro")
    expect(response).to have_http_status 200
  end

  # request_password_update
  it "request update password" do
    request_sign_in user
    request_password_update(
      password: "new password",
      password_confirmation: "new password"
    )
    expect(response).to have_http_status 200
  end


  # response_header
  it "return response header" do
    expect(response_header).to include(uid: user.email)
  end

  # response_body
  it "return response body" do
    expect(response_body).to include(:data)
  end

  # response_data
  it "return response data" do
    expect(response_data).to include(name: user.name)
  end
end
