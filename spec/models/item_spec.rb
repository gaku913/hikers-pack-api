require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "association with User" do
    let(:item) { create(:item) }

    it "belongs to user" do
      expect(item.user).to be_an_instance_of(User)
    end

    it "Even if item is deleted, user is not deleted" do
      user = item.user
      item.destroy
      expect { user.reload }.not_to raise_error
    end
  end

  describe "association with PackItem" do
    let(:user) { create(:user) }
    let(:item) { create(:item, user: user) }
    let(:packs) { create_list(:pack, 2, user: user) }

    before do
      item.packs << packs
    end

    it "has many PackItems" do
      expect(item.pack_items[0]).to be_an_instance_of(PackItem)
      expect(item.pack_items[1]).to be_an_instance_of(PackItem)
    end

    it "removes associated packitems, when itself is removed" do
      pack_item = item.pack_items[0]
      item.destroy
      expect { pack_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "association with Pack" do
    let(:user) { create(:user) }
    let(:item) { create(:item, user: user) }
    let(:packs) { create_list(:pack, 2, user: user) }

    before do
      item.packs << packs
    end

    it "has many Packs" do
      expect(item.packs[0]).to be_an_instance_of(Pack)
      expect(item.packs[1]).to be_an_instance_of(Pack)
    end

    it "Even if item is deleted, pack is not deleted" do
      pack = item.packs[0]
      item.destroy
      expect { pack.reload }.not_to raise_error
    end
  end

  describe "validation" do
    it "is unique at [ :name, :weight ]" do
      create(:item, name: "Item", weight: 0)
      item = build(:item, name: "Item", weight: 0) # 2つ目のitem
      expect(item).not_to be_valid
    end

    it "allow null at weight" do
      item = build(:item, weight: nil)
      expect(item).to be_valid
    end
  end
end
