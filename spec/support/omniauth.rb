def set_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' })
end
