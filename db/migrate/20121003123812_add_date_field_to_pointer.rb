class AddDateFieldToPointer < ActiveRecord::Migration[4.2]
  def change
    add_column :pointers, :record_date, :date
  end
end
