class UsersController < ApplicationController
  before_action :set_user, only: [:finish_signup]


  def finish_signup
    if params.include?(:user)
      @user.update(user_params)
      redirect_to root_path, notice: 'Successfully authenticated.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
