class Desire < ActiveRecord::Base
  # attr_accessible :pointer_id, :stat, :user_id

  belongs_to :pointer
  belongs_to :user

end
