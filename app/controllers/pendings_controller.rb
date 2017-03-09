class PendingsController < ApplicationController
  before_action :require_login

  def new
    current_user_authorised?(params[:user_id], root_path)

    @pending = Pending.new
  end

  def create
    current_user_authorised?(params[:user_id], root_path)

    @pending = Pending.new(pending_params)
    @pending.status = "waiting"
    @pending.user_id = current_user.id

    if @pending.save
      redirect_to user_pending_path(user_id: current_user.id, id: @pending)
    else
      redirect_to new_pending_path
    end

  end

  def show
    current_user_authorised?(params[:user_id], root_path)

    @pending = Pending.find(params[:id])
  end

  def destroy
    current_user_authorised?(params[:user_id], root_path)
    
    pending = Pending.find(params[:id])

    pending.delete_related_matches_matchstatuses
    pending.destroy

    redirect_to user_path(current_user)
  end

  private

  def pending_params
    return_hash = params.require(:pending).permit(:city, :datetime)

    if params[:pending][:activity_id] == "0"
      activity_id = Activity.get_id(params[:pending][:activity]) 
      return_hash[:activity_id] = activity_id
    else
      return_hash[:activity_id] = params[:pending][:activity_id].to_i
    end

    return return_hash
  end
end
