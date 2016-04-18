class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_uri, :path, :current_controller, :current_action, :indefinite_articlerize, :signin_link
  before_action :require_login, :configure_octokit

  def index
  end

  def require_login
    unless current_user
      flash[:warning] = "Please log in."
      redirect_to root_url
    end
  end

  def configure_octokit
    Octokit.configure do |c|
      c.access_token = session[:access_token]
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end

  def current_uri
    @current_uri ||= request.env['PATH_INFO']
  end

  def path
    @path ||= Rails.application.routes.recognize_path(current_uri)
  end

  def current_controller
    @current_controller ||= path[:controller]
  end

  def current_action
    @current_action ||= path[:action]
  end

  def signin_link(options = {})
    "#{request.base_url}/auth/github?#{options.to_query}"
  end

  def check_user_is_instructor
    unless current_user.instructor?
      flash[:warning] = "You do not have permissions to access this page."
      redirect_to root_url
    end
  end

end
