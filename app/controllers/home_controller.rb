include MapMethods

class HomeController < ApplicationController
  #@@resc_arr =[]
  #before_action proc { @@resc_arr =[] }, :except => [:all_list]

  def index
    @last_points = Pointer.limit(10).order("rec_date DESC, id ASC")
    @top_points = Pointer.limit(10).order("rating DESC, rec_date DESC, id ASC")
  end

  def map
    user_id = current_user.blank? ? 0 : current_user.id
    stat = params[:stat]
    my = params[:my] == '1'

    if params[:q].blank?
      pointers = Pointer.select_pointers_by_user(user_id, my, stat)
    else
      q = params[:q]
      pointers = Pointer.where {full_desc =~ "%#{q}%"}
      #pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
      #                              FROM pointers
      #                              LEFT OUTER JOIN desires
      #                              ON pointers.id = desires.pointer_id AND desires.user_id = #{user_id}
      #                              where pointers.full_desc LIKE '%#{q}%'")
      @q = q
    end

    @size = pointers.size
    @zoom = params[:zoom] ? params[:zoom] : 9

    respond_to do |format|
      format.html do
        @json = build_map(pointers)
      end
      format.mobile
      format.js do
        unless params.has_key?(:from) || params.has_key?(:to)
          @json = build_map(pointers)
        else
          render nothing: true
        end
      end
    end
  end

  def full_desc
    id = params[:id]
    @desc = (Pointer.find(id).full_desc).delete("\r")

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def search
    user_id = current_user.blank? ? 0 : current_user.id

    if params[:q].blank?
      @q = ""
      pointers = Pointer.all
    else
      q = params[:q]

      unless params.has_key?(:slider) && params[:slider] == "slider"
        render :js => "window.location.href = '#{map_url(:q => q)}'"
        return
      end

      pointers = Pointer.where {full_desc =~ "%#{q}%"}

      #pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
      #                              FROM pointers
      #                              LEFT OUTER JOIN desires
      #                              ON pointers.id = desires.pointer_id AND desires.user_id = #{user_id}
      #                              where pointers.full_desc LIKE '%#{q}%'")
      @q = q
    end

    @size = pointers.size
    @json = build_map(pointers)

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def get_direction_info
    @from = params[:from]
    @to = params[:to]
    render :layout => false
  end

  def options

  end

end
