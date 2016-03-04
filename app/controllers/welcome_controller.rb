class WelcomeController < ApplicationController
  skip_before_action :require_login

  def index
    render inline: "<%= link_to 'Sign in with Github as Instructor', '/auth/github?role=instructor' %>"
  end
end
