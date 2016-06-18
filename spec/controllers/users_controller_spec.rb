require 'rails_helper'

RSpec.describe UsersController do
  describe 'PATCH #finish_signup' do
    sign_in_user
    before { patch :finish_signup, id: @user, user: { email: 'new@user.com' } }

    it 'update user email' do
      expect(@user.reload.email).to eq 'new@user.com'
    end

    it { response.should redirect_to root_path }
  end
end
