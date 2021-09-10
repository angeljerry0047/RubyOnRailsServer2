class SessionsController < Devise::SessionsController
  def create
    @commit       = sessions_params.fetch(:commit)
    linkedin_data = session['devise.linkedin_data']

    if linkedin_data && current_user.uid.nil?
      current_user.uid      = linkedin_data.uid
      current_user.provider = 'linkedin'
      flash[:notice]        = 'Your account is synced with LinkedIn'
      current_user.save!
    end

    self.resource = warden.authenticate!(auth_options)

    set_flash_message(:notice, :signed_in) if is_navigational_format?

    sign_in(resource_name, resource)

    if @commit == 'Join In Person'
      redirect_to oneClickRegister_opportunities_path
    elsif resource.incomplete_profile?
      redirect_to edit_user_registration_path
      flash[:notice] = 'Please complete your profile.'
    else
      redirect_to after_sign_in_path_for(resource)
    end
  end

  protected

  def sessions_params
    User.permitted(params).merge(params.permit(:commit))
  end
end
