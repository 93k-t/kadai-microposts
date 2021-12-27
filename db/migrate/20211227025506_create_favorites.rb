class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :micropost, null: false, foreign_key: true

      t.timestamps
      
      # user_id と micropost_id の組み合わせの重複を許さない制約
      t.index [:user_id,:micropost_id],unique: true
    end
  end
end
