class CreateFaces < ActiveRecord::Migration[5.2]
  def change
    create_table :faces do |t|
      t.string :body
      t.timestamps null: false
    end
  end
end
