class AddRatingFieldToPointers < ActiveRecord::Migration
  def change
    add_column :pointers, :rating, :integer, :default => 0
  end
end
