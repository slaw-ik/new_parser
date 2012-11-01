class Desire < ActiveRecord::Base
  attr_accessible :pointer_id, :status, :user_id

  belongs_to :pointer
  belongs_to :user

end
