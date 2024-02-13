require 'rails_helper'

RSpec.describe "Api::V1::Packs", type: :request do

  let(:pack1) { create(:pack, title: "Pack1") }
  let(:pack2) { create(:pack, title: "Pack2") }
  let(:user) { create(:user, packs: [pack1, pack2]) }

  # ログイン状態
  context "when user is authenticated" do
    before do
      request_sign_in user
    end

    describe "GET #index" do
      it "returns http success and packs list" do
        get api_v1_packs_path, headers: auth_headers
        expect(response).to have_http_status(:success)
      end
      it "returns packs list" do
        get api_v1_packs_path, headers: auth_headers
        expect(response_body[0]).to include(title: "Pack1")
        expect(response_body[1]).to include(title: "Pack2")
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get api_v1_pack_path(pack1.id), headers: auth_headers
        expect(response).to have_http_status(:success)
      end
      it "returns pack1" do
        get api_v1_pack_path(pack1.id), headers: auth_headers
        expect(response_body).to include(title: "Pack1")
      end
    end

    describe "POST #create" do
      it "returns http success" do
        post api_v1_packs_path,
          headers: auth_headers,
          params: { pack: attributes_for(:pack, user_id: user.id) }
        expect(response).to have_http_status(:success)
      end
      it "creates a new pack" do
        expect {
          post api_v1_packs_path,
          headers: auth_headers,
          params: { pack: attributes_for(:pack, user_id: user.id) }
        }.to change(Pack, :count).by(1)
      end
    end

    describe "PATCH #update" do
      it "updates the pack" do
        new_title = "New Title"
        patch api_v1_pack_path(pack1.id),
          headers: auth_headers,
          params: { pack: { title: new_title } }
        expect(response).to have_http_status(:success)
        expect(pack1.reload.title).to eq(new_title)
      end
    end

    describe "DELETE #destroy" do
      it "destroys the pack" do
        expect {
          delete api_v1_pack_path(pack1.id),
          headers: auth_headers
        }.to change(Pack, :count).by(-1)
        expect(response).to have_http_status(:success)
      end
    end
  end

  # ログアウト状態
  # Memo: error(401):ログインもしくはアカウント登録してください。
  context "when user is not authenticated" do
    before do
      request_sign_out
    end

    describe "GET #index" do
      it "returns status 401" do
        get api_v1_packs_path, headers: auth_headers
        expect(response).to have_http_status(401)
      end
    end

    describe "GET #show" do
      it "returns status 401" do
        get api_v1_pack_path(pack1.id), headers: auth_headers
        expect(response).to have_http_status(401)
      end
    end

    describe "POST #create" do
      it "returns status 401" do
        post api_v1_packs_path,
          headers: auth_headers,
          params: { pack: attributes_for(:pack, user_id: user.id) }
        expect(response).to have_http_status(401)
      end
    end

    describe "PATCH #update" do
      it "returns status 401" do
        new_title = "New Title"
        patch api_v1_pack_path(pack1.id),
          headers: auth_headers,
          params: { pack: { title: new_title } }
        expect(response).to have_http_status(401)
      end
    end

    describe "DELETE #destroy" do
      it "returns status 401" do
        delete api_v1_pack_path(pack1.id),
        headers: auth_headers
        expect(response).to have_http_status(401)
      end
    end

  end
end
