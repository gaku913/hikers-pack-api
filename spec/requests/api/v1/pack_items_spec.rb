require 'rails_helper'

RSpec.describe "Api::V1::PackItems", type: :request do
  let(:user) { create(:user) }
  let(:pack) { create(:pack, user: user) }
  let(:items) { create_list(:item, 5, user: user) }

  before do
    pack.items << items
  end

  # ログイン状態
  context "when user is authenticated" do
    before do
      request_sign_in user
    end

    describe "GET #index" do
      it "returns http success" do
        get api_v1_pack_items_path(pack), headers: auth_headers
        expect(response).to have_http_status(:ok) #200
      end
      it "returns packs list" do
        get api_v1_pack_items_path(pack), headers: auth_headers
        expect(response_body.length).to eq(5)
      end
      it "containe name, weight, quontity" do
        get api_v1_pack_items_path(pack), headers: auth_headers
        expect(response_body[0]).to include(
          id: a_kind_of(Integer),
          quantity: a_kind_of(Integer),
          item: {
            name: a_kind_of(String),
            weight: a_kind_of(Integer)
          }
        )
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get api_v1_pack_item_path(pack, pack.pack_items[0]), headers: auth_headers
        expect(response).to have_http_status(:ok) #200
      end
      it "containe name, weight, quontity" do
        get api_v1_pack_item_path(pack, pack.pack_items[0]), headers: auth_headers
        expect(response_body).to include(
          id: a_kind_of(Integer),
          quantity: a_kind_of(Integer),
          item: {
            name: a_kind_of(String),
            weight: a_kind_of(Integer)
          }
        )
      end
    end

    describe "POST #create" do
      context "with valid parameters" do # validationの検証はモデルのテストでやるべき
        it "returns http status :created" do
          post api_v1_pack_items_path(pack),
            headers: auth_headers,
            params: { pack_item: { item: attributes_for(:item) }}
          expect(response).to have_http_status(:created) #201
        end

        it "creates a new item and pack_item" do
          expect {
            post api_v1_pack_items_path(pack),
              headers: auth_headers,
              params: { pack_item: { item: attributes_for(:item) }}
          }
          .to change(Item, :count).by(1)
          .and change(PackItem, :count).by(1)
        end

        it "creates a new item with nil weight" do
          expect {
            post api_v1_pack_items_path(pack),
              headers: auth_headers,
              params: { pack_item: { item: attributes_for(:item, weight: nil) }}
          }
          .to change(Item, :count).by(1)
          .and change(PackItem, :count).by(1)
          item = Item.order(created_at: :desc).first
          expect(item.weight).to be_nil
        end

        it "creates a new pack_item with quantity" do
          expect {
            post api_v1_pack_items_path(pack),
              headers: auth_headers,
              params: { pack_item: {
                item: attributes_for(:item),
                quantity: 10,
              }}
          }
          .to change(Item, :count).by(1)
          .and change(PackItem, :count).by(1)
          pack_item = PackItem.order(created_at: :desc).first
          expect(pack_item.quantity).to eq(10)
        end

        it "does not create a new item, If the item already exists." do
          item = create(:item, user_id: user.id)
          expect {
            post api_v1_pack_items_path(pack),
              headers: auth_headers,
              params: { pack_item: {
                item: attributes_for(:item, name: item.name, weight: item.weight)
              }}
          }
          .to change(Item, :count).by(0)
          .and change(PackItem, :count).by(1)
        end

        it "does not create a new pack_item, If it aleady exists." do
          item = create(:item, user_id: user.id)
          create(:pack_item, pack_id: pack.id, item_id: item.id)
          post api_v1_pack_items_path(pack),
            headers: auth_headers,
            params: { pack_item: {
              item: attributes_for(:item, name: item.name, weight: item.weight)
            }}
          expect(response).to have_http_status(:unprocessable_entity) #422
        end

      end

      context "with invalid item parameters" do
        it "does not let name be null" do
          post api_v1_pack_items_path(pack),
            headers: auth_headers,
            params: { pack_item: {item: { name: nil }}}
          expect(response).to have_http_status(:unprocessable_entity) #422
        end
      end

      context "with invalid pack_item parameters" do
        it "does not let :quantity be null" do
          post api_v1_pack_items_path(pack),
            headers: auth_headers,
            params: { pack_item: {
              item: attributes_for(:item),
              quantity: nil,
            }}
          expect(response).to have_http_status(:unprocessable_entity) #422
        end

        it "does not let :checked be null" do
          post api_v1_pack_items_path(pack),
            headers: auth_headers,
            params: { pack_item: {
              item: attributes_for(:item),
              checked: nil,
            }}
          expect(response).to have_http_status(:unprocessable_entity) #422
        end
      end
    end

    describe "PATCH #update" do
      context "PackItem" do
        it "update pack_item" do
          pack_item = pack.pack_items[0]
          patch api_v1_pack_item_path(pack, pack_item),
            headers: auth_headers,
            params: { pack_item: { quantity: 10, checked: true}}
          expect(response).to have_http_status(:ok) #200
          pack_item.reload
          expect(pack_item.quantity).to eq(10)
          expect(pack_item.checked).to be_truthy
        end
      end

      context "Item" do
        it "create new item, and switch to it" do
          pack_item = pack.pack_items[0]
          item_id = pack_item.item_id
          patch api_v1_pack_item_path(pack, pack_item),
            headers: auth_headers,
            params: { pack_item: {
              item: attributes_for(:item, name: "New Item")
            }}
          pack_item.reload

          expect(pack_item.item.name).to eq("New Item")
          expect(pack_item.item_id).not_to eq(item_id)
        end

        it "switch items, if the item already exists" do
          item = create(:item, user: user)
          pack_item = pack.pack_items[0]
          patch api_v1_pack_item_path(pack, pack_item),
            headers: auth_headers,
            params: { pack_item: {
              item: attributes_for(:item, name: item.name, weight: item.weight)
            }}
          pack_item.reload

          expect(pack_item.item_id).to eq(item.id)
        end

        it "delete item that are not associated to any pack" do
          pack_item = pack.pack_items[0]
          old_item = pack_item.item
          new_item = create(:item, user: user)
          patch api_v1_pack_item_path(pack, pack_item),
            headers: auth_headers,
            params: { pack_item: {
              item: attributes_for(:item, name: new_item.name, weight: new_item.weight)
            }}
          expect { old_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "DELETE #destroy" do
      context "PackItem" do
        it "delete pack_item" do
          pack_item = pack.pack_items[0]
          delete api_v1_pack_item_path(pack, pack_item), headers: auth_headers
          expect { pack_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "Item" do
        it "delete item that are not associated to any pack" do
          pack_item = pack.pack_items[0]
          item = pack_item.item
          delete api_v1_pack_item_path(pack, pack_item), headers: auth_headers
          expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "PATCH #update_checked" do
      it "checked on: one pack_item" do
        pack_item = pack.pack_items[0]
        patch update_checked_api_v1_pack_items_path(pack),
          headers: auth_headers,
          params: { pack_items: [{ id: pack_item.id, checked: true }] }
        expect(response).to have_http_status(:no_content) #204
        pack_item.reload
        expect(pack_item.checked).to be true
      end

      it "checked off: one pack_item" do
        pack_item = pack.pack_items[0]
        patch update_checked_api_v1_pack_items_path(pack),
          headers: auth_headers,
          params: { pack_items: [{ id: pack_item.id, checked: false }]}
        pack_item.reload
        expect(pack_item.checked).to be false
      end

      it "checked on: some pack_items" do
        flags = [true, true, true]
        pack_items = pack.pack_items.take(flags.length)
        patch update_checked_api_v1_pack_items_path(pack),
          headers: auth_headers,
          params: {
            pack_items: pack_items.map.with_index do |pack_item, index|
              { id: pack_item.id, checked: flags[index] }
            end
          }
        pack_items.each_with_index do |pack_item, index|
          pack_item.reload
          expect(pack_item.checked).to eq flags[index]
        end
      end

      it "checked off: some pack_items" do
        flags = [false, false, false]
        pack_items = pack.pack_items.take(flags.length)
        patch update_checked_api_v1_pack_items_path(pack),
          headers: auth_headers,
          params: {
            pack_items: pack_items.map.with_index do |pack_item, index|
              { id: pack_item.id, checked: flags[index] }
            end
          }
        pack_items.each_with_index do |pack_item, index|
          pack_item.reload
          expect(pack_item.checked).to eq flags[index]
        end
      end

      it "checked on|off: some pack_items" do
        flags = [false, true, false]
        pack_items = pack.pack_items.take(flags.length)
        patch update_checked_api_v1_pack_items_path(pack),
          headers: auth_headers,
          params: {
            pack_items: pack_items.map.with_index do |pack_item, index|
              { id: pack_item.id, checked: flags[index] }
            end
          }
        pack_items.each_with_index do |pack_item, index|
          pack_item.reload
          expect(pack_item.checked).to eq flags[index]
        end
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
        get api_v1_pack_items_path(pack), headers: auth_headers
        expect(response).to have_http_status(:unauthorized) #401
      end
    end

    describe "GET #show" do
      it "returns status 401" do
        get api_v1_pack_item_path(pack, pack.pack_items[0]), headers: auth_headers
        expect(response).to have_http_status(:unauthorized) #401
      end
    end

    describe "POST #create" do
      it "returns status 401" do
        post api_v1_pack_items_path(pack),
          headers: auth_headers,
          params: { pack_item: { item: attributes_for(:item) }}
        expect(response).to have_http_status(:unauthorized) #401
      end
    end

    describe "PATCH #update" do
      it "returns status 401" do
        patch api_v1_pack_item_path(pack, pack.pack_items[0]),
          headers: auth_headers,
          params: { pack_item: { quantity: 10 }}
        expect(response).to have_http_status(:unauthorized) #401
      end
    end

    describe "DELETE #destroy" do
      it "returns status 401" do
        delete api_v1_pack_item_path(pack, pack.pack_items[0]), headers: auth_headers
        expect(response).to have_http_status(:unauthorized) #401
      end
    end

    describe "PATCH #update_checked" do
      it "returns status 401" do
        patch update_checked_api_v1_pack_items_path(pack),
          headers: auth_headers,
          params: { pack_items: [{ id: 1, checked: true }] }
        expect(response).to have_http_status(:unauthorized) #401
      end
    end

  end

end
