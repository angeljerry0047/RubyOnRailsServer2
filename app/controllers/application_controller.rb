class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to user_path(current_user), flash: { error: exception.message }
  end

  before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?

    if request.path != '/users' &&
       request.path != '/users/sign_in' &&
       request.path != '/users/sign_up' &&
       request.path != '/users/password/new' &&
       request.path != '/users/password/edit' &&
       request.path != '/users/confirmation' &&
       request.path != '/users/sign_out' &&
       !request.xhr? # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      edit_user_registration_url(protocol: 'https')
    else
      stored_location_for(:user) || resource
    end
  end

  def current_pac
    Pac.where(owner_id: current_user.id)
       .where(in_progress: true)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(*User.attribute_whitelist)
    end

    devise_parameter_sanitizer.permit(:sing_in) do |u|
      u.permit(:email, :password, :remember_me)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(*User.attribute_whitelist)
    end
  end
end
