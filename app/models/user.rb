class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

    has_many :desires

  def is_admin?
    role == 1
  end


    class << self
      def current_user=(user)
        Thread.current[:current_user] = user
      end

      def current_user
        Thread.current[:current_user]
      end
    end


end
