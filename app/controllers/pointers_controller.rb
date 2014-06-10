class PointersController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:import_ratings]

  def index
    @pointers = Pointer.search_in_radius(:radius => params[:radius], :lng => params[:lng], :lat => params[:lat])

    pointers_for_json = if params['current_count'].to_i != @pointers.size
                          @pointers.map { |obj| obj.attributes.except("rec_date", "description", "id", "gmaps", "created_at", "updated_at") }
                        else
                          []
                        end

    respond_to do |format|
      format.json { render :text => pointers_for_json.to_json, :layout => false }
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
      @json = build_map(pointers)

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
    ParsingMethods::parse_coords
    redirect_to root_path
  end

  def import_ratings
    puts "========================================"
    puts params
    puts "========================================"
    my_status = 200

    unless params["_json"].blank?
      begin
        Pointer.transaction do
          params["_json"].each do |data|
            where_params = data["loc_position"].split(' ')
            # pointer = Pointer.where("latitude LIKE ? AND longitude LIKE ?", where_params[0], where_params[1]).first
            # Fix for PostgreSQL
            pointer = Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude = #{where_params[0]} AND longitude = #{where_params[1]}").first
            by_rating = data['resetable_rating'].to_i
            pointer.increment!(:rating, by = by_rating)
          end
        end
      rescue ActiveRecord::Rollback
        my_status = 501
      end
    end

    respond_to do |format|
      format.json { render :nothing => true, status: my_status }
    end
  end

end
