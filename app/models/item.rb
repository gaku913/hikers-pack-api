class Item < ApplicationRecord
  belongs_to :user
  has_many :pack_items, dependent: :destroy
  has_many :packs, through: :pack_items
  validates :name, presence: true, uniqueness: { scope: :weight }
end
