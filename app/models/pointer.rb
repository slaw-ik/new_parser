class Pointer < ActiveRecord::Base

  attr_accessible :description, :full_desc, :gmaps, :latitude, :longitude, :rec_date
  acts_as_gmappable :process_geocoding => false

  validates :latitude, :presence => true
  validate :double_coordinates

  #================== Validations =====================
  def double_coordinates
    #errors.add(:latitude, "double") unless Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude LIKE #{latitude.round(4)} AND longitude LIKE #{longitude.round(4)}").blank?
    a = latitude.round(4)
    b = longitude.round(4)
    errors.add(:latitude, "double") unless Pointer.where{(latitude =~ a) & (longitude =~ b)}.blank?

  end
  #====================================================

  def gmaps4rails_address
    #self.address #describe how to retrieve the address from your model
    "#{self.latitude}, #{self.longitude}"
  end

  def gmaps4rails_infowindow
    "<p style ='font-size: 12px; font-family = 'verdana'; '> #{self.description} <p><br><a data-remote='true' href='/home/full_desc?bla=#{self.id}'>Full description (see under the map)</a>"
  end
end
