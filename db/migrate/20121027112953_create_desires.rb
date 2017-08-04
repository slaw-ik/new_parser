class CreateDesires < ActiveRecord::Migration[4.2]
  def change
    create_table :desires do |t|
      t.integer :pointer_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
