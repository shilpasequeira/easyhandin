module CoursesHelper
  def user_organizations
    GetOrganizations.perform
  end

  def html_url(repository)
    repository["html_url"]
  end

  def ssh_url(repository)
    repository["ssh_url"]
  end
end
