class AddDateFieldToPointer < ActiveRecord::Migration
  def change
    add_column :pointers, :record_date, :date
  end
end
