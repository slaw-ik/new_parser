module MapMethods

  def build_map(collection, options = {})
    collection.to_gmaps4rails do |point, marker|
      marker.infowindow render_to_string(:partial => "pointers/infowindow", :locals => {:point => point})
      stat_dir = options[:stat].blank? ? point.try(:stat) : (point.try(:stat).blank? ? options[:stat] : point.stat)
      width = options[:width].blank? ? 32 : options[:width]
      height = options[:height].blank? ? 37 : options[:height]
      marker.picture({:picture => "/assets/markers/#{stat_dir}/pin-export.png",
                      :width => width,
                      :height => height})
    end
  end

end