Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
  provider :github, "f77bb8c822c35869e1b1", "a39a6b255c2c0a2f83c24c208098578e86db1de7"
  else
    provider :github,
    Rails.application.credentials.github[:client_id],
    Rails.application.credentials.github[:client_secret]
  end
end
