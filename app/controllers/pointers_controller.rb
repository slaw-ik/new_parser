class PointersController < ApplicationController
  def index
    if params[:radius].present? && params[:lng].present? && params[:lat].present?
      radius = params[:radius]
      lng = params[:lng]
      lat = params[:lat]
      query = "SELECT
                latitude,longitude,description, (
                6371 * acos(
                    cos(radians(#{lat}) )
                * cos( radians( latitude ) )
                * cos( radians( longitude ) - radians(#{lng}) )
                + sin( radians(#{lat}) )
                * sin( radians( latitude ) )
                ) )
                AS distance
                FROM pointers
                HAVING distance < #{radius}"

      @pointers = Pointer.find_by_sql(query)
      else
        @pointers = Pointer.all
      end


    #========== Finding the places in a radius ==============================
    #SELECT
    #latitude,longitude,description, (
    #6371 * acos(
    #    cos(radians(48.616667) )
    #* cos( radians( latitude ) )
    #* cos( radians( longitude ) - radians(22.3) )
    #+ sin( radians(48.616667) )
    #* sin( radians( latitude ) )
    #) )
    #AS distance
    #FROM pointers
    #HAVING distance < 0.9
    #========================================================================

    respond_to do |format|
      format.json { render :text => @pointers.to_json, :layout => false }
      format.html
      format.mobile { render :text => @pointers.to_json, :layout => false }
    end
  end

  def new
  end

  def create
  end

  def show
    @pointer = Pointer.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def options

  end

end
