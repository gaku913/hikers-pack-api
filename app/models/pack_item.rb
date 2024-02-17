class PackItem < ApplicationRecord
  belongs_to :pack
  belongs_to :item

  validates :item_id, :pack_id, presence: true
  # nilを禁止。blankは許可する。
  validates :quantity, :checked, exclusion: { in: [nil] }
  # 同じitemが同じpackに重複して追加されないようにする
  validates_uniqueness_of :item_id, scope: :pack_id
end
