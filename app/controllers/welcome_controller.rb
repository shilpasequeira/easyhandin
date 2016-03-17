class WelcomeController < ApplicationController
  skip_before_action :require_login, only: :index
  layout "login"
  def index
  end
end
