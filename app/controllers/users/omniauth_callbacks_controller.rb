class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  include AfterSignIn

  def linkedin
    @user, @changeset = User.find_or_create_from_auth_hash(request.env["omniauth.auth"], current_user)
    sign_in_and_render
  end

  def salesforce
    @user, @changeset = User.find_or_create_from_auth_hash(request.env["omniauth.auth"], current_user)
    sign_in_and_render
  end

  def developer
    @user, @changeset = User.find_or_create_from_auth_hash(request.env['omniauth.auth'], current_user)
    sign_in_and_render
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  protected 

  def user_params
    user_params = User.permitted(params)
    user_params.permit(:action)
    user_params
  end

  private

  def sign_in_and_render
    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => user_params[:action].capitalize) if is_navigational_format?

      # if signing in forget about it.
      redirect_to after_sign_in_path_for(@user)
    else
      flash[:notice] = "We don't recognize you in our system, feel free to sign up or sign in under a different e-mail"
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      render 'devise/registrations/new'
    end
  end

end
