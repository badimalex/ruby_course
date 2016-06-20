require 'rails_helper'

RSpec.describe UsersController do
  describe 'PATCH #finish_signup' do
    sign_in_user
    before { patch :finish_signup, id: @user, user: { email: 'updated@user.email' } }

    it 'send email notification' do
      expect{
        patch :finish_signup, id: @user, user: { email: 'updated@user.email' }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'update user email' do
      expect(@user.reload.unconfirmed_email).to eq 'updated@user.email'
    end
  end
end
