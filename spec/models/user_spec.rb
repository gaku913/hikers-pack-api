require 'rails_helper'

RSpec.describe User, type: :model do
  describe "association with Pack" do
    let(:user) { create(:user, packs_count: 2) }

    it "has many packs" do
      expect(user.packs[0]).to be_an_instance_of(Pack)
      expect(user.packs[1]).to be_an_instance_of(Pack)
    end

    it "removes all associated packs, when itself is removed" do
      pack1 = user.packs[0]
      pack2 = user.packs[1]
      user.destroy

      expect { pack1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { pack2.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "association with Item" do
    let(:user) { create(:user, items_count: 2) }

    it "has many Items" do
      expect(user.items[0]).to be_an_instance_of(Item)
      expect(user.items[1]).to be_an_instance_of(Item)
    end

    it "removes associated items, when itself is removed" do
      item = user.items[0]
      user.destroy
      expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
