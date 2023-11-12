class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to chat_path
    else
      @error = 'Invalid credentials'
      render :new, status: 422
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to sign_in_path
  end
end
