class HomeController < ApplicationController

  @@resc_arr =[]
  before_filter proc { @@resc_arr =[] }, :except => [:all_list]

  def index
    @last_points = Pointer.limit(10).order("rec_date DESC, id ASC")

  end

  def map
    pointers = Pointer.all
    @size = pointers.size
    @json = pointers.to_gmaps4rails
    @zoom = params[:zoom] ? params[:zoom] : 9
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

      pointers = Pointer.where{full_desc =~ "%#{q}%"}

      @size = pointers.size
      @json = pointers.to_gmaps4rails
      render :action => :map
    end
  end

  def show_pointer_on_map
    unless params[:id].blank?
      id = params[:id]

      pointers = Pointer.find(id)
      @desc = pointers.full_desc
      @json = pointers.to_gmaps4rails
      @size = 1

      render :action => :map, :locals => {:zoom => 12, :center_lat => pointers.latitude, :center_long => pointers.longitude}
    end
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


end
