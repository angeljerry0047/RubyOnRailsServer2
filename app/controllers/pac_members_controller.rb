require 'icalendar'

class PacMembersController < ApplicationController

  before_filter :authenticate_user!

  def create
    @pac                 = current_pac.first
    @current_pac_members = @pac.pac_members.pluck(:member_id)
    user                 = User.find(pac_members_params[:user_id])

    if @current_pac_members.include?(user.id)
      redirect_to request.referer, notice: 'User Already in team'
    else
      @pac_member        = @pac.pac_members.build
      @pac_member.member = user


      respond_to do |format|
        if @pac_member.save
          format.html { redirect_to find_users_path, notice: 'Team Member was successfully added.' }

          format.json { 
            render json: @pac_member,
            status: :created,
            location: @pac_member
          }
        else
          format.html { render action: "new" }
          format.json { render json: @pac_member.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def invite
    if pac_members_params[:commit] == 'Invite'
      # NOTE (cmhobbs) where is .invite! defined?  is this still used?
      @user = User.invite!(
        { :email => pac_members_params[:emails], :name => pac_members_params[:name]},
        current_user
      )

      @pac               = current_pac.first
      @pac_member        = @pac.pac_members.build
      @pac_member.member = @user
      @pac_member.save

      redirect_to find_users_path, notice: 'serve2perform membership was emailed.'
    end
  end

  def register
    @pac               = Pac.find(pac_members_params[:id])
    @pac_member        = @pac.pac_members.build
    @pac_member.member = current_user

    if @pac_member.save
      Notifier.pac_membership_request(@pac_member).deliver_now!
      redirect_to skills_path, notice: 'Your Membership request has been delivered.'
    end
  end

  def approve
    @pac_member = PacMember.find(pac_members_params[:id])
  end

  def update
    @pac_member = PacMember.find(pac_members_params[:id])
    @pac_member.update_attributes(approved: true)
    Notifier.pac_membership_approval(@pac_member).deliver_now!
    redirect_to skills_path, notice: 'Your Membership has been approved.'
  end

  def destroy
    @pac_member = PacMember.find(pac_members_params[:id])
    @pac_member.destroy

    respond_to do |format|
      if request.referer.include?("approve")
        format.html { redirect_to skills_path, notice: 'Team Membership was declined.' }
        format.json { head :no_content } 
      else
        format.html { redirect_to request.referer, notice: 'Team Member was successfully removed.' }
        format.json { head :no_content }
      end
    end
  end

  protected

  def pac_members_params
    Pac
      .permitted(params)
      .merge(User.permitted(params))
      .merge(params.permit(:commit, :emails, :user_id, :name, :id))
  end


end
