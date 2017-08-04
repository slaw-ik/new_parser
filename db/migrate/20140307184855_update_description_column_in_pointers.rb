class UpdateDescriptionColumnInPointers < ActiveRecord::Migration[4.2]
  def up
    Pointer.all.each do |point|
      point.description = point.description.gsub("['", "").gsub("']", "").gsub("[", "").gsub("]", "")
      point.save!
    end
  end

  def down
    Pointer.all.each do |point|
      point.description = "["+point.description+"]"
      point.save!
    end
  end
end
