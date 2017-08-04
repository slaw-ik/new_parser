class CreatePointers < ActiveRecord::Migration[4.2]
  def change
    create_table :pointers do |t|
      t.float :latitude
      t.float :longitude
      t.string :description
      t.text :full_desc
      t.boolean :gmaps

      t.timestamps
    end
  end
end
