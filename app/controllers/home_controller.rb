class HomeController < ApplicationController

  @@resc_arr =[]
  before_filter proc { @@resc_arr =[] }, :except => [:all_list]

  def index
    @last_points = Pointer.limit(10).order("rec_date DESC, id ASC")

  end

  def map
    #pointers = Pointer.all
    user_id = current_user.blank? ? 0 : current_user.id

    pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.`status`
                                    FROM pointers
                                    LEFT OUTER JOIN desires
                                    ON pointers.id = desires.pointer_id AND desires.user_id = #{user_id}")

    @size = pointers.size
    @json = build_map(pointers, {status: "default"})

    @zoom = params[:zoom] ? params[:zoom] : 9
  end

  def my_places
    user_id = current_user.blank? ? 0 : current_user.id
    status = params[:status]
    unless status.blank?
      pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.`status` FROM pointers, desires, users
	                                    WHERE desires.user_id = #{user_id}
                                            AND desires.status = #{status}
                                            AND pointers.id = desires.pointer_id ")
    else
      pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.`status` FROM pointers, desires, users
	                                    WHERE desires.user_id = #{user_id} and pointers.id = desires.pointer_id ")
    end

    @size = pointers.size
    @json = build_map(pointers)

    render :action => :map
  end

  def full_desc
    id = params[:bla]
    @desc = (Pointer.find(id).full_desc).delete("\r")

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def all_list
    @pointers = Pointer.limit(20).order("rec_date DESC, id ASC")
    @resc_array = @@resc_arr
    @resc_arr = []
  end

  def dynamic_content
    @index = params[:index].to_i * 20 - 20
    unless @add_pointers.blank?
      @pointers = @add_pointers
    else
      @pointers = Pointer.limit(20).order("rec_date DESC, id ASC").offset(@index)
      @add_pointers = Pointer.limit(20).order("rec_date DESC, id ASC").offset(@index + 20)
    end
  end

  def search
    unless params[:q].blank?
      q = params[:q]

      pointers = Pointer.where { full_desc =~ "%#{q}%" }

      @size = pointers.size
      @json = build_map(pointers, {status: "default"})

      render :action => :map
    end
  end

  def show_pointer_on_map
    user_id = current_user.blank? ? 0 : current_user.id

    unless params[:id].blank?
      id = params[:id]

      pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.`status`
                                    FROM pointers
                                    LEFT OUTER JOIN desires
                                    ON pointers.id = desires.pointer_id AND desires.user_id = #{user_id}
                                    where pointers.id = #{id}")

      @desc = pointers.first.full_desc
      @json = build_map(pointers, {status: "default"})

      @size = 1

      render :action => :map, :locals => {:zoom => 12, :center_lat => pointers.first.latitude, :center_long => pointers.first.longitude}
    end
  end

  def get_direction

  end

  def get_direction_info
    from = params[:from]
    to = params[:to]

    @result = Gmaps4rails.destination({"from" => from,
                                       "to" => to},
                                      {"language"  => "ru",
                                       "mode"      => "DRIVING",
                                       "avoid"     => ["tolls", "highways"],
                                       "language"  => "ru" },
                                      "pretty" )

    #=========================Result Sample=====================================
    #[{"duration"=>{"text"=>"19 mins",
    #               "value"=>1127.0},
    #  "distance"=>{"text"=>"20.9 km",
    #               "value"=>20883.0},
    #  "steps"=>[{"distance"=>{"text"=>"13.7 km",
    #                          "value"=>13666},
    #             "duration"=>{"text"=>"12 mins",
    #                          "value"=>727},
    #             "end_location"=>{"lat"=>48.71946000000001, "lng"=>22.59635},
    #             "html_instructions"=>"Head southwest on T0712",
    #             "start_location"=>{"lat"=>48.67308000000001, "lng"=>22.75927},
    #             "travel_mode"=>"DRIVING"},
    #            {"distance"=>{"text"=>"7.2 km",
    #                          "value"=>7217},
    #             "duration"=>{"text"=>"7 mins",
    #                          "value"=>400},
    #             "end_location"=>{"lat"=>48.74445, "lng"=>22.67609},
    #             "html_instructions"=>"Turn right onto T0723",
    #             "start_location"=>{"lat"=>48.71946000000001, "lng"=>22.59635},
    #             "travel_mode"=>"DRIVING"}],
    #  "polylines"=>"[{\"coded_array\":\"wmahHmd|iCz@|DhB`JXxBRjDr@vNJfEiA`NiAlPyBx\\\\q@rKeG|_AkAvRWbC_@xBcDpMqAjE{BhHmBvG{@xDuAzKi@~EwCxU{ApM}@lHsCbVsC`VsCx[q@jIm@zGq@dHoApKWhBaCrLyApGsCvMmBnJk@vB_BlEoBvEu@bByBdFcBjFyCzJgAjD_HjTgHbUkCxIuCjJwE~O_G`TW~AwA|Us@vLo@hKa@pHU`EOlDY|C{AbMyCbT{@nG{@~Ha@~Dk@|FiAjLyAhPg@lCsBvJsD`PkCrLwFvV_BfHsBlJoCrMoEjRgCtIsBxGwAxEu@dAk@Zo@FiDNwFR{@LeAf@wEpDuMnKkBbByBvA{E|CoDvBg@Z\"},{\"coded_array\":\"sojhHej|hCQcA_@oAAuAFoGIkEg@kAeA]e@w@HsFrEkRxCeOfCqOn@iQWqImGyi@uFuTwGqSeEqM_JmSc_@_r@w\\\\so@{LkW{ByE_Cu@kFO_EwDiByEqAoFgAaFuAaH}CiQoAaBqBg@iBeBm@}CYyEiBuAeBwDTqJFcMx@_JhBsGF}@\"}]"}]
    #=============================================================================

    render :layout => false
  end



  def parse
    require 'nokogiri'
    require 'open-uri'

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
        pt = pp.text.gsub!("done ", ">><<")
        pt.gsub!(/\n/, '')
        pt.scan(%r{<<.*?>>}).each_with_index do |element, index|
          coord = element.scan(%r{\s?\d{2}.\d{4,7}\s*,\s*\d{2}.\d{4,7}\s?})
          #@arr << element
          @arr << element.gsub!("<<", "").gsub!(">>", "")
          @coord << coord.first
          unless coord.blank?
            #lat_lon =  coord.first.gsub!("(", "").gsub!(")", "").split(", ")
            lat_lon = coord.first.split(",")
            latitude = lat_lon.first
            longitude = lat_lon.last
            short_desc = element.scan(%r{^.*?\.}).to_s
            #puts element
            #puts "====="
            #puts short_desc
            short_desc.gsub!('"', "'")
            begin
              Pointer.create(:latitude => latitude.to_f.round(4), :longitude => longitude.to_f.round(4), :description => short_desc, :full_desc => element, :rec_date => record_date)
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
    render :action => :index
    #redirect_to root_path
  end

  private

  def build_map(collection, options = {})
    collection.to_gmaps4rails do |point, marker|
      marker.infowindow render_to_string(:partial => "pointers/infowindow", :locals => {:point => point})
      #marker.title "#{city.name}"
      #marker.json({ :population => city.population})
      #options[:status] = point.status.blank? ? options[:status] : nil
      status_dir = options[:status].blank? ? point.try(:status) : (point.status.blank? ? options[:status] : point.status)
      width = options[:width].blank? ? 32 : options[:width]
      height = options[:height].blank? ? 37 : options[:height]
      marker.picture({:picture => "/assets/markers/#{status_dir}/pin-export.png",
                      :width => width,
                      :height => height})
    end

  end


end
