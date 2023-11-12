class RegistrationsController < ApplicationController
  def new
    @user = User.new()
  end

  def create
    @user = User.new(sign_up_user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to chat_path
    else
      render :new, status: 422
    end
  end

  private
  def sign_up_user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
