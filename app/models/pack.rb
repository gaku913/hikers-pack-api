class Pack < ApplicationRecord
  belongs_to :user
  has_many :pack_items, dependent: :destroy
  has_many :items, through: :pack_items
end
