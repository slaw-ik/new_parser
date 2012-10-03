class RenameFieldInPonters < ActiveRecord::Migration
  def up
    rename_column :pointers, :record_date, :rec_date
  end

  def down

  end
end
