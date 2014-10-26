class UpdateDescriptionInPointer < ActiveRecord::Migration
  def up
    Pointer.all.each do |point|
      short_desc = point.full_desc.match(%r{^.*?(?:^[\u0430-\u044F\u0410-\u042F]{1,3}\.(.*?))*(?:\s[\u0430-\u044F\u0410-\u042F]{1,3}\.(.*?))*(?:\d\.(.*?))*(\.|$)})[0].gsub('"', "'")
      if short_desc.length > 255
        puts "------------------------------------------"
        puts short_desc
        puts "++++++++++++++++++++++++++++++++++++++++++"
        short_desc = short_desc[0, 250]+"..."
        puts short_desc
        puts "------------------------------------------"
      end
      point.description = short_desc
      point.save!
    end
  end

  def down
  end

end
