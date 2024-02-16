require 'rails_helper'

RSpec.describe Pack, type: :model do

  describe "association with User" do
    let(:pack) { create(:pack) }
    it "belongs to user" do
      expect(pack.user).to be_an_instance_of(User)
    end

    it "Even if pack is deleted, user is not deleted" do
      user = pack.user
      pack.destroy

      expect { user.reload }.not_to raise_error
    end
  end

  describe "association with Items" do
    let(:pack) { create(:pack, items_count: 2) }

    it "has many Items" do
      expect(pack.items[0]).to be_an_instance_of(Item)
      expect(pack.items[1]).to be_an_instance_of(Item)
    end

    it "Even if pack is deleted, item is not deleted" do
      item = pack.items[0]
      pack.destroy
      expect { item.reload }.not_to raise_error
    end
  end

  describe "association with PackItems" do
    let(:pack) { create(:pack, items_count: 2) }

    it "has many PackItems" do
      expect(pack.pack_items[0]).to be_an_instance_of(PackItem)
      expect(pack.pack_items[1]).to be_an_instance_of(PackItem)
    end

    it "removes all associated packitems, when itself is removed" do
      pack_item = pack.pack_items[0]
      pack.destroy
      expect { pack_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
