require 'rails_helper'

RSpec.describe PackItem, type: :model do
  describe "association with Pack" do
    let(:pack_item) { create(:pack_item) }

    it "belongs to Pack" do
      expect(pack_item.pack).to be_an_instance_of(Pack)
    end

    it "Even if packitem is deleted, pack is not deleted" do
      pack = pack_item.pack
      pack_item.destroy
      expect { pack.reload }.not_to raise_error
    end
  end

  describe "association with Item" do
    let(:pack_item) { create(:pack_item) }

    it "belongs to Item" do
      expect(pack_item.item).to be_an_instance_of(Item)
    end

    it "Even if packitem is deleted, item is not deleted" do
      item = pack_item.item
      pack_item.destroy
      expect { item.reload }.not_to raise_error
    end
  end

  describe "validations" do
    it "is unique at [ :pack, :item]" do
      pack = create(:pack)
      item = create(:item)
      create(:pack_item, pack: pack, item: item)
      pack_item = build(:pack_item, pack: pack, item: item) # ２つ目のレコード
      expect(pack_item).not_to be_valid
    end
  end
end
