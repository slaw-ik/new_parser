class PointersController < ApplicationController
  def index
    @pointers = Pointer.search_in_radius(:radius => params[:radius], :lng => params[:lng], :lat => params[:lat])

    respond_to do |format|
      format.json { render :text => @pointers.to_json, :layout => false }
      format.html
      format.mobile { render :text => @pointers.to_json, :layout => false }
    end
  end

  def list
    @all_pointers = Pointer.order("rec_date DESC, id ASC")
    @pointers = @all_pointers.limit(20)
  end

  def dynamic_content
    @index = params[:index].to_i * 20 - 20
    unless @add_pointers.blank?
      @pointers = @add_pointers
    else
      @pointers = Pointer.limit(20).order("rec_date DESC, id ASC").offset(@index)
      @add_pointers = Pointer.limit(20).order("rec_date DESC, id ASC").offset(@index + 20)
    end
    render 'dynamic_content.js'
  end

  def new
  end

  def create
  end

  def show
    @pointer = Pointer.find(params[:id])
  end

  def show_pointer_on_map
    user_id = current_user.blank? ? 0 : current_user.id

    unless params[:id].blank?
      id = params[:id]

      pointers = Pointer.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
                                    FROM pointers
                                    LEFT OUTER JOIN desires
                                    ON pointers.id = desires.pointer_id AND desires.user_id = #{user_id}
                                    where pointers.id = #{id}")

      @desc = pointers.first.full_desc
      @json = build_map(pointers, {stat: "default"})

      @size = 1

      #render :action => :map, :locals => {:zoom => 12, :center_lat => pointers.first.latitude, :center_long => pointers.first.longitude}
      render :template => "home/map", :locals => {:zoom => 12, :center_lat => pointers.first.latitude, :center_long => pointers.first.longitude}
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end



  def parse
    ParsingMethods::parse
    redirect_to root_path
  end

end
