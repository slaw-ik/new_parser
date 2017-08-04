class AddRatingFieldToPointers < ActiveRecord::Migration[4.2]
  def change
    add_column :pointers, :rating, :integer, :default => 0
  end
end
