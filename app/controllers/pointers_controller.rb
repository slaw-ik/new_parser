class PointersController < ApplicationController
  def index
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
end
