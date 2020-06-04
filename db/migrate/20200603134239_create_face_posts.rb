class CreateFacePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :face_posts do |t|
      t.integer :person_id
      t.integer :face_id
      t.timestamps null: false
    end
  end
end
