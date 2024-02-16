class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :user, foreign_key: true # 外部キー: user
      t.string :name, null: false           # 名前
      t.integer :weight                     # 重量 (g)

      t.timestamps
    end
    add_index :items, [:name, :weight], unique: true
  end
end
