class CreatePackItems < ActiveRecord::Migration[7.0]
  def change
    create_table :pack_items do |t|
      t.references :pack, null: false, foreign_key: true # 外部キー: pack
      t.references :item, null: false, foreign_key: true # 外部キー: item
      t.integer :quantity, null: false, default: 1     # 個数
      t.boolean :checked, null: false, default: false  # チェック済み判定

      t.timestamps
    end
    add_index :pack_items, [:pack_id, :item_id], unique: true
  end
end
