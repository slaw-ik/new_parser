module ParsingMethods

  require 'nokogiri'
  require 'open-uri'

  def parse_coords

    #url = "#{::Rails.root}/todo.html"
    url = "http://poi.uzhgorod.ua/todo.html"
    doc = Nokogiri::HTML(open(url))

    @arr = []
    @coord = []
    @resc_arr =[]
    record_date = Date.today

    doc.css("body").each do |p|
      date = p.content.scan(%r{\d{2}\/\d{2}\/\d{4}}).first
      record_date = date.to_date unless date.blank?
    end

    doc.css("p").each do |pp|
      if pp.text.mb_chars.include?("done")
        pt = pp.text.gsub("done ", ">><<").gsub(/\n/, ' ').gsub(/\s+/, ' ')
        pt.scan(%r{<<.*?>>}).each_with_index do |element, index|
          coord = element.scan(%r{\s?\d{2}.\d{4,7}\s*,\s*\d{2}.\d{4,7}\s?})
          #@arr << element
          begin
            full_desc = element.scan(%r{(<<)(\s{0,5}\(?\d{0,2}\)?\s{0,5}-\s{0,5})(.*)(>>)})[0][2]
          rescue NoMethodError
            puts element
            # ignored
          end
          @arr << full_desc
          @coord << coord.first
          unless coord.blank?
            #lat_lon =  coord.first.gsub!("(", "").gsub!(")", "").split(", ")
            lat_lon = coord.first.split(",")
            latitude = lat_lon.first
            longitude = lat_lon.last
            short_desc = full_desc.match(%r{^.*?(?:^[\u0430-\u044F\u0410-\u042F]{1,3}\.(.*?))*(?:\s[\u0430-\u044F\u0410-\u042F]{1,3}\.(.*?))*(?:\d\.(.*?))*(\.|$)})[0].gsub('"', "'")
            #puts element
            #puts "====="
            #puts short_desc
            begin
              Pointer.create(:latitude => latitude.to_f.round(4),
                             :longitude => longitude.to_f.round(4),
                             :description => short_desc,
                             :full_desc => full_desc,
                             :rec_date => record_date)
                #puts "========="
                #puts "OK"
                #puts "========="
            rescue
              @resc_arr << latitude + ", " + longitude
              #puts "========="
              #puts "FAIL"
              #puts "========="
            end
          end
          #if index==2
          #  break
          #end
        end
      end
    end
    #set_var(@resc_arr)
    #@@resc_arr = @resc_arr
    @pointers = Pointer.all
    #@last_points = @pointers.last(10)
    #render :action => :index
  end

end