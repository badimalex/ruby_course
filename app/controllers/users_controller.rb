class UsersController < ApplicationController
  before_action :set_user, only: [:finish_signup]


  def finish_signup
    if params.include?(:user)
      @user.update_attributes!(unconfirmed_email: user_params[:email])
      @user.send_confirmation_instructions
      redirect_to confirm_email_path
    end
  end

  def confirm_email
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
