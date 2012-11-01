class DesiresController < ApplicationController

  def create_visit
    @link_id = params[:id]
    record = current_user.desires.where(:pointer_id => @link_id).first

    if record.blank?
      new_desire = Desire.new(:user_id => current_user.id, :pointer_id => @link_id, :status => 0)
      if new_desire.save
        @success = 'success'
        @message = 'Place was successfully added to your desires.'
      else
        @success = 'error'
        @message = 'Error saving. Please try again later.'
      end
    else
      if record.status == 0
        @success = 'error'
        @message = 'This place already is in your desires.'
      else
        record.update_attributes(:status => 0)
        @success = 'success'
        @message = 'Place was successfully added to your desires.'
      end
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def set_visited
    @link_id = params[:id]
    record = current_user.desires.where(:pointer_id => @link_id).first

    if record.blank?
      new_desire = Desire.new(:user_id => current_user.id, :pointer_id => @link_id, :status => 1)
      if new_desire.save
        @success = 'success'
        @message = 'Place was successfully marked as visited.'
      else
        @success = 'error'
        @message = 'Error saving. Please try again later.'
      end
    else
      if record.status == 1
        @success = 'error'
        @message = 'This place is already visited.'
      else
        record.update_attributes(:status => 1)
        @success = 'success'
        @message = 'Place was successfully marked as visited.'
      end
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
