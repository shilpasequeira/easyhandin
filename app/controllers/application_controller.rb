class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_uri, :path, :current_controller, :current_action

  def index
    # render inline: "<%= link_to 'Sign in with Github as Instructor', '/auth/github?role=instructor' %>"
    render template: "index/index"
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
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
end
