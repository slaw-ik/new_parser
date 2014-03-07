class Pointer < ActiveRecord::Base

  attr_accessible :description, :full_desc, :gmaps, :latitude, :longitude, :rec_date
  acts_as_gmappable :process_geocoding => false

  has_many :desires

  validates :latitude, :presence => true
  #validate :double_coordinates, :on => :create

  validates :latitude, :presence => true, :uniqueness => {:scope => :longitude}

  #================== Validations =====================
  #def double_coordinates
  #  #errors.add(:latitude, "double") unless Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude LIKE #{latitude.round(4)} AND longitude LIKE #{longitude.round(4)}").blank?
  #  a = latitude.round(4)
  #  b = longitude.round(4)
  #  db_type = ActiveRecord::Base.connection.adapter_name
  #
  #  if db_type.index('PostgreSQL') == 0
  #    errors.add(:latitude, "double") unless Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude = #{a} AND longitude = #{b}").blank?
  #  elsif db_type.index('Mysql') == 0
  #    errors.add(:latitude, "double") unless Pointer.find_by_sql("SELECT * FROM pointers WHERE latitude LIKE '#{a}' AND longitude LIKE '#{b}'").blank?
  #  end
  #
  #end

  #====================================================

  #Finding the places in a radius
  #<i>Pointers.search_in_radius(options = {})</i>  ->  array of pointers
  #Options:
  #:radius - radius in which you wanna search a points
  #:lat - latitude of your target point
  #:lng - longitude of your target point
  def self.search_in_radius(options = {})

    if options[:radius] && options[:lng] && options[:lat] && options[:radius] != 0
      radius = options[:radius]
      lng = options[:lng]
      lat = options[:lat]

      query = "SELECT latitude, longitude, description
                FROM pointers
                GROUP BY id
                HAVING (
                 6371 * acos(
                     cos(radians(#{lat}) )
                    * cos( radians( latitude ) )
                    * cos( radians( longitude ) - radians(#{lng}) )
                    + sin( radians(#{lat}) )
                    * sin( radians( latitude ) )
                    ) ) < #{radius}"

      return self.find_by_sql(query)
    else
      return self.all
    end

  end

  def self.select_pointers_by_user(user_id = 0, my = false, stat = nil)

    if user_id != 0
      if my
        unless stat.blank?
          self.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
                                      FROM pointers, desires, users
	                                    WHERE desires.user_id = #{user_id}
                                            AND desires.stat = #{stat}
                                            AND pointers.id = desires.pointer_id ")
        else
          self.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
                                      FROM pointers, desires, users
	                                    WHERE desires.user_id = #{user_id}
                                            AND pointers.id = desires.pointer_id ")
        end
      else
        self.find_by_sql("SELECT pointers.id, pointers.latitude, pointers.longitude, pointers.description, pointers.full_desc, desires.stat
                                    FROM pointers
                                    LEFT OUTER JOIN desires
                                        ON pointers.id = desires.pointer_id
                                        AND desires.user_id = #{user_id}")
      end
    else
      self.all
    end

  end

  def gmaps4rails_address
    "#{self.latitude}, #{self.longitude}"
  end
end
