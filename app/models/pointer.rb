class Pointer < ActiveRecord::Base

  attr_accessible :description, :full_desc, :gmaps, :latitude, :longitude, :rec_date
  acts_as_gmappable :process_geocoding => false

  has_many :desires

  validates :latitude, :presence => true
  validate :double_coordinates

  #================== Validations =====================
  def double_coordinates
    #errors.add(:latitude, "double") unless Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude LIKE #{latitude.round(4)} AND longitude LIKE #{longitude.round(4)}").blank?
    a = latitude.round(4)
    b = longitude.round(4)
    db_type = ActiveRecord::Base.connection.adapter_name

    if db_type.index('PostgreSQL') == 0
      errors.add(:latitude, "double") unless Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude = #{a} AND longitude = #{b}").blank?
    elsif db_type.index('Mysql') == 0
      errors.add(:latitude, "double") unless Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude LIKE #{a} AND longitude LIKE #{b}").blank?
    end

  end

  #====================================================

  def gmaps4rails_address
    #self.address #describe how to retrieve the address from your model
    "#{self.latitude}, #{self.longitude}"
  end

  #def gmaps4rails_infowindow
  #  descr_link = "<p style ='font-size: 12px; font-family = 'verdana'; '>
  #                  #{self.description}
  #                </p>
  #                <br>
  #                <a data-remote='true' href='/home/full_desc?bla=#{self.id}'>
  #                  Full description (see under the map)
  #                </a>
  #                <br>"
  #
  #  unless User.current_user.blank?
  #    visit_link = "<a id='v_link_#{self.id}' data-remote='true' href = '/create_visit/#{self.id}' >
  #                    <i class = 'icon-map-marker'>
  #                      I want to visit this place
  #                    </i>
  #                  </a>
  #                  <br>
  #                  <a id='f_link_#{self.id}' data-remote='true' href = '/set_visited/#{self.id}' >
  #                    <i class = 'icon-flag'>
  #                      Mark as visited place
  #                    </i>
  #                  </a>
  #                  <br>
  #                  <br>
  #                  <br>"
  #  else
  #    visit_link = ""
  #  end
  #
  #  return descr_link + visit_link
  #
  #end
  #
  #def gmaps4rails_marker_picture
  #  {
  #      #"picture" => self.image_path, # image_path column has to contain something like '/assets/my_pic.jpg'.
  #      :picture => "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-color/shadow-1/border-dark/symbolstyle-contrast/symbolshadowstyle-dark/gradient-iphone/pin-2.png",
  #      :width => 32, #beware to resize your pictures properly
  #      :height => 37 #beware to resize your pictures properly
  #  }
  #end
end
