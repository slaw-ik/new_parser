class AddIndexToPointers < ActiveRecord::Migration[4.2]
  def change
    add_index :pointers, [:latitude, :longitude], unique: true
  end
end

