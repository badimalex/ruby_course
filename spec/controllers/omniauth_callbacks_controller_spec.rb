require 'rails_helper'

RSpec.describe OmniauthCallbacksController do
  describe 'GET #twitter' do
    context 'user already has authorization'
    context 'user has not authorization' do
      before do
        set_omniauth
        get :twitter
      end
      it { response.should redirect_to finish_signup_path(assigns(:user).id) }

      it 'assign user' do
        expect(assigns(:user)).to be_a(User)
      end

    end
  end
end

def set_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { })
  request.env['devise.mapping'] = Devise.mappings[:user]
  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
end
