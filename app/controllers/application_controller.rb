class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def delayed_job_admin_authentication
    authorize
  end
  
  private
  
  def load_config
    Post.load_config
    Post.load_path
    Post.published_path
    @site = Post.load_defaults
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end
end
