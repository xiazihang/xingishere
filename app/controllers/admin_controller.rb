class AdminController < ApplicationController
  before_action :admin?

  def admin?
    user = User.find(session[:user_id]) if session[:user_id].present?
    if !user || !user.admin?
      render_404_page
    end
  end
end
