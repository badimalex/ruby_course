require 'rails_helper'

RSpec.describe OmniauthCallbacksController do
  describe 'GET #twitter' do
    context 'user already has authorization'
    context 'user has not authorization' do
      before do
        set_omniauth
        get :twitter
      end
      it 'render form fill email' do
        expect(response).to render_template 'fill_email'
      end
    end
  end

  describe 'POST #twitter' do
    before do
      set_omniauth
      get :twitter
      post :twitter, email: 'new@user.com'
    end
    it { response.should redirect_to root_path }
  end
end

def set_omniauth
  request.env['devise.mapping'] = Devise.mappings[:user]
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { })
end
