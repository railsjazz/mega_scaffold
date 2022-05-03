class ApplicationController < ActionController::Base

  def admin?
    true
  end

  def current_user
    User.first
  end

end
