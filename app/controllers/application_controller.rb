class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user 
    @user = User.new
  end
end
