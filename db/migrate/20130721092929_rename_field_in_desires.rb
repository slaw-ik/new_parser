class RenameFieldInDesires < ActiveRecord::Migration
  def up
    rename_column :desires, :status, :stat
  end

  def down
    rename_column :desires, :stat, :status
  end
end
