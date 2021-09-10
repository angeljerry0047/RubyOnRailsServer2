class UserLicensesController < ApplicationController

  before_filter :authenticate_user!
  authorize_resource :class => false

  def manage
    @org = current_user.organization
    @users = @org.users.each_slice(4).to_a
    @mobileusers = @org.users.each_slice(2).to_a
  end

  def update_many
    licensed_users = []

    user_licenses_params[:users].each do |key,value|
      if value == {"active_license" => "1"}
        licensed_users.push(key)
      end
    end

    if licensed_users.count <= current_user.organization.user_licenses
      User.update(user_licenses_params[:users].keys, user_licenses_params[:users].values)
      flash[:notice] = "Users updated"
      redirect_to manage_user_licenses_path
    else
      flash[:notice] = "These changes would exceed your number of user licenses. Please purchase more user licenses or deactivate users as necessary to active new users."
      redirect_to manage_user_licenses_path
    end
  end

  protected

  def user_licenses_params
    params.permit(users: User.attribute_whitelist)
  end
end
