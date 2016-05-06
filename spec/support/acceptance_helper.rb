module AcceptanceHelper
  def sign_up_with(email, password)
    visit new_user_registration_path  
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_on 'Sign up'
  end

  def sign_in
    visit new_user_session_path
    user = create(:user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end
