class CreatePacks < ActiveRecord::Migration[7.0]
  def change
    create_table :packs do |t|
      t.references :user, foreign_key: true # 外部キー: user
      t.string :title, null: false          # タイトル
      t.string :memo                        # メモ
      t.date :start_date, null: false       # 開始日
      t.date :end_date, null: false         # 終了日

      t.timestamps
    end
  end
end
