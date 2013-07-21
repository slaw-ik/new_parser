class RenameFieldInDesires < ActiveRecord::Migration
  def up
    rename_column :desires, :status, :stat
  end

  def down
  end
end
