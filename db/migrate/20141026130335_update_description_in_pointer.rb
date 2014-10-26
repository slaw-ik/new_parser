class UpdateDescriptionInPointer < ActiveRecord::Migration
  def up
    Pointer.all.each do |point|
      short_desc = point.full_desc.match(%r{^.*?(?:[\u0430-\u044F\u0410-\u042F]{1,3}\.(.*?))*(?:\d\.(.*?))*(\.|$)})[0]
      short_desc.gsub!('"', "'")
      point.description = short_desc
      point.save!
    end
  end

  def down
  end

end
