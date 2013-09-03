module MapMethods

  def build_map(collection, options = {})
    collection.to_gmaps4rails do |point, marker|
      marker.infowindow render_to_string(:partial => "pointers/infowindow", :locals => {:point => point})
      stat_dir = dir_name(point, options[:stat])
      width = options[:width].blank? ? 32 : options[:width]
      height = options[:height].blank? ? 37 : options[:height]
      marker.picture({:picture => "/assets/markers/#{stat_dir}/pin-export.png",
                      :width => width,
                      :height => height})
    end
  end

  def dir_name(point, stat)
    if stat.blank?
      if point.has_attribute?(:stat)
        unless point.stat.blank?
          point.stat
        else
          "default"
        end
      else
        "default"
      end
    else
      stat
    end
  end

end