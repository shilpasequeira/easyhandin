module CoursesHelper
  def user_organizations
    begin
      GetOrganizations.perform(session[:access_token])
    rescue => e
      nil
    end
  end
end
