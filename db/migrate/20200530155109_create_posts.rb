class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :person_id
      t.integer :user_id
      t.string :summary
      t.string :body
      t.string :image
      t.timestamps null: false
    end
  end
end
