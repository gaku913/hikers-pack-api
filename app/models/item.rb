class Item < ApplicationRecord
  belongs_to :user
  has_many :pack_items
  has_many :packs, through: :pack_items
end
