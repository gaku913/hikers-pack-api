class PackItem < ApplicationRecord
  belongs_to :pack
  belongs_to :item

  validates_uniqueness_of :item_id, scope: :pack_id # 同じitemが同じpackに重複して追加されないようにする
end
