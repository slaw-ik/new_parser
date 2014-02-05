class HomeController < ApplicationController

  #@@resc_arr =[]
  #before_filter proc { @@resc_arr =[] }, :except => [:all_list]

  def index
    @last_points = Pointer.limit(10).order("rec_date DESC, id ASC")
  end

  def map
    user_id = current_user.blank? ? 0 : current_user.id
    stat = params[:stat]
    my = params[:my] == '1'

    unless params[:q].blank?
      q = params[:q]

      pointers = Pointer.where { full_desc =~ "%#{q}%" }

      #pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
      #                              FROM pointers
      #                              LEFT OUTER JOIN desires
      #                              ON pointers.id = desires.pointer_id AND desires.user_id = #{user_id}
      #                              where pointers.full_desc LIKE '%#{q}%'")
      @q = q
    else
      pointers = Pointer.select_pointers_by_user(user_id, my, stat)
    end

    @size = pointers.size
    @zoom = params[:zoom] ? params[:zoom] : 9

    respond_to do |format|
      format.html { @json = build_map(pointers) }
      format.mobile
      format.js { @json = build_map(pointers) }
    end
  end

  def full_desc
    id = params[:id]
    @desc = (Pointer.find(id).full_desc).delete("\r")

    respond_to do |format|
      format.js { render :layout => false }
    end
  end


  def search
    user_id = current_user.blank? ? 0 : current_user.id

    unless params[:q].blank?
      q = params[:q]

      unless params.has_key?(:slider) && params[:slider] == "slider"
        render :js => "window.location.href = '#{map_url(:q => q)}'"
        return
      end

      pointers = Pointer.where { full_desc =~ "%#{q}%" }

      #pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
      #                              FROM pointers
      #                              LEFT OUTER JOIN desires
      #                              ON pointers.id = desires.pointer_id AND desires.user_id = #{user_id}
      #                              where pointers.full_desc LIKE '%#{q}%'")
      @q = q
    else
      @q = ""
      pointers = Pointer.all
    end

    @size = pointers.size
    @json = build_map(pointers)

    respond_to do |format|
      format.js { render :layout => false }
    end
  end


  def get_direction

  end

  def get_direction_info
    from = params[:from]
    to = params[:to]

    @result = Gmaps4rails.destination({"from" => from,
                                       "to" => to},
                                      {"language" => "ru",
                                       "mode" => "DRIVING",
                                       "avoid" => ["tolls", "highways"],
                                       "language" => "ru"},
                                      "pretty")

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

  def options

  end

end
