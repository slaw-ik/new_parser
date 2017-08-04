class UpdateDescriptionInPointer < ActiveRecord::Migration[4.2]
  def up
    Pointer.all.each do |point|
      full_desc = point.full_desc.gsub(/\n/, ' ').gsub(/\s+/, ' ').match(%r{(\s{0,5}\(?\d{0,2}\)?\s{0,5}-\s{0,5})(.*)})[2]
      short_desc = full_desc.match(%r{^.*?(?:^[\u0430-\u044F\u0410-\u042F]{1,3}\.(.*?))*(?:\s[\u0430-\u044F\u0410-\u042F]{1,3}\.(.*?))*(?:\d\.(.*?))*(\.|$)})[0].gsub('"', "'")
      if short_desc.length > 255
        puts "------------------------------------------"
        puts short_desc
        puts "++++++++++++++++++++++++++++++++++++++++++"
        short_desc = short_desc[0, 250]+"..."
        puts short_desc
        puts "------------------------------------------"
      end
      point.description = short_desc
      point.full_desc = full_desc
      point.save!
    end
  end

  def down
  end

end
