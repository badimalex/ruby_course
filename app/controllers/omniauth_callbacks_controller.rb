class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    auth_params = request.env['omniauth.auth']
    # Rails.logger.debug auth_params
    Rails.logger.debug params[:email]
    Rails.logger.debug '********************************************'
    # auth.info[:email]
    if(params[:email])
      redirect_to root_path
    else
      render 'devise/omniauth_callbacks/fill_email'
    end
  end

  def email_params
    params.permit(:email)
  end
end
