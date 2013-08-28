class PointersController < ApplicationController
  def index
    @pointers = Pointer.search_in_radius(:radius => params[:radius], :lng => params[:lng], :lat => params[:lat])

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
