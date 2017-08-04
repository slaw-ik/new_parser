class ApplicationController < ActionController::Base

  protect_from_forgery

  before_action :set_current_user, :prepare_for_mobile

  def set_current_user
    User.current_user = current_user
  end

  private

  def mobile_device?
    request.user_agent =~ /Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile/
  end

  helper_method :mobile_device?

  def prepare_for_mobile
    #session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end


end
