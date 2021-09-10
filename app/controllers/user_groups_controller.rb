class UserGroupsController < ApplicationController
  before_filter :authenticate_user!

  def register
    @user_group = UserGroup.new({:group_id => user_groups_params[:organization_id], :member_id => current_user.id})
    if @user_group.save
      Notifier.user_group_membership_request(@user_group).deliver_now!
      redirect_to skills_path, :notice => "Thanks for registering! The admin has been emailed."
    else
      redirect_to skills_path, :flash => {:error => @user_group.errors.messages.values.join }
    end
  end

  def manage
    @org = current_user.organization
    @users = @org.members.each_slice(4).to_a
    @mobileusers = @org.members.each_slice(2).to_a
  end

  def destroy_many
    UserGroup.destroy(user_groups_params[:user_groups])

    respond_to do |format|
      format.html { redirect_to manage_user_groups_path, notice: "Members updated" }
    end
  end

  def destroy
    @user_group = UserGroup.find(user_groups_params[:id])
    @user_group.destroy

    respond_to do |format|
      format.html { redirect_to organization_path(current_user.organization.slug), notice: "Member was sucessfully removed." }
      format.json { head :no_content }
    end
  end

  def approve
    @user_group = UserGroup.find(user_groups_params[:id])
    @user_group_org = @user_group.group
    @user_group_admin = @user_group_org.users.where(:role => 'admin')
  end

  def update
    @user_group = UserGroup.find(user_groups_params[:id])
    @user_group.update_attributes(approved: true)
    Notifier.user_group_membership_approval(@user_group).deliver_now!
    redirect_to skills_path, :notice => "Successfully Approved Membership"
  end

  protected

  def user_groups_params
    UserGroup
      .permitted(params)
      .merge(params.permit(user_groups: UserGroup.attribute_whitelist))
      .merge(params.permit(:id, :organization_id))
  end

end
