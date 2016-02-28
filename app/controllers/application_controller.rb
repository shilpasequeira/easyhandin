class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    render inline: "<%= link_to 'Sign in with Github as Instructor', '/auth/github?role=instructor' %>"
  end
end
