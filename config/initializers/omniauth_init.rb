Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, :cas_server => 'https://login.dartmouth.edu/cas'
end
