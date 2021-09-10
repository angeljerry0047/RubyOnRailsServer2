class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, only: [:update]

  def update
    super
    # required for settings form to submit when password is left blank
    # NOTE (cmhobbs) ^^ why do we care?
    # if registrations_params[:user][:password].blank?
    #   registrations_params[:user].delete('password')
    #   registrations_params[:user].delete('password_confirmation')
    #   registrations_params[:user].delete('current_password')
    # end

    # @user = User.find(current_user.id)

    # if @user.updated_at == registrations_params[:user][:updated_at]
    #   success = if registrations_params[:user][:password].blank?
    #               @user.update_attributes(registrations_params[:user])
    #             else
    #               @user.update_with_password(registrations_params[:user])
    #             end

    #   if success
    #     set_flash_message :notice, :updated
    #     # Sign in the user bypassing validation in case his password changed
    #     # NOTE (cmhobbs) ^^ this also shouldn't matter
    #     sign_in @user, bypass: true

    #     if registrations_params[:frm] == 'newuser'
    #       redirect_to after_update_newuser_path_for(resource)
    #     else
    #       redirect_to root_url
    #     end

    #   else
    #     render 'edit'
    #   end
    # else
    #   set_flash_message :notice, :concurrency
    #   render 'edit'
    # end
  end

  protected

  def after_update_newuser_path_for(_resource)
    # users_historical_opportunities_path(resource)
    # organization_path(current_user.organization)
    root_url
  end

  def after_update_path_for(resource)
    user_url(resource)
  end

  def after_sign_up_path_for(_resource)
    UserGroup.create(group_id: 257, member_id: current_user.id, approved: true)

    # FIXME: (cmhobbs) there's definitely a more efficient way to do this
    parent_organization = Organization.where(domain: current_user.email[/@.*\z/].delete('@')).first

    # NOTE: (cmhobbs) add a user to a group if they have a matching domain in their email address
    if parent_organization
      UserGroup.create(group_id: parent_organization.id, member_id: current_user.id, approved: true)
    end

    if registrations_params.fetch(:commit) == 'Join In Person'
      oneClickRegister_opportunities_path
    elsif registrations_params.fetch(:commit) == 'Join Virtually'
      oneClickWebRegister_opportunities_path
    else
      edit_user_registration_path(frm: 'newuser')
    end
  end

  def registrations_params
    # TODO: This is a holdover while we upgrade gems.  Essentially the
    # intermediate state we're in on gem versions has left us with a
    # Devise and Rails that both need to be updated in tandem for usage
    # with strong_params.  Devise is the bear, here.  However, as we
    # don't specifically know the version we're going to land on, we
    # are choosing not to stop and debug this specific spot for too long.
    # Instead, we're going to permit it all for now and come back once
    # things have settled.
    #
    # Here's what it used to look like:
    #
    #   User.permitted(params).merge(params.permit(:commit))
    #
    params.permit!
    # params.require(:user).permit(*User.attribute_whitelist)
  end

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params['password']&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except('current_password'))
  end
end
