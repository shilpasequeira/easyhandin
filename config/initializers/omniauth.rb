SETUP_PROC = lambda do |env| 
  request = Rack::Request.new(env)

  if request.params["role"] == "instructor"
    scope = "user:email,admin:org"
  else
    scope = "user:email"
  end

  env['omniauth.strategy'].options[:scope] = scope
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], setup: SETUP_PROC
end
