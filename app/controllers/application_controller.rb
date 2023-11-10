class ApplicationController < ActionController::Base
  before_action :set_current_user

  def index
    if Current.user == nil
      redirect_to controller: :session, action: :new
    end
  end

  def set_current_user
    if session[:user_id]
      Current.user = User.find_by(id: session[:user_id])
    end
  end
end
