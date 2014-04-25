class AddIndexToPointers < ActiveRecord::Migration
  def change
    add_index :pointers, [:latitude, :longitude], unique: true
  end
end

