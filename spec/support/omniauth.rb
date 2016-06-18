def set_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'facebook@user.com' })
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { })
end
