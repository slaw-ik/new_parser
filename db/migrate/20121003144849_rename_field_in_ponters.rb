class RenameFieldInPonters < ActiveRecord::Migration[4.2]
  def up
    rename_column :pointers, :record_date, :rec_date
  end

  def down

  end
end
