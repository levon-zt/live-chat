class AuthenticationController < ApplicationController
  before_action :redirect_if_not_logged_in

  def redirect_if_not_logged_in
    if Current.user == nil
      redirect_to controller: :sessions, action: :new
    end
  end
end
