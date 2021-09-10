# FIXME (cmhobbs) use decent_exposure here
class MentorshipCirclesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_mentorship_circle, only: [:show, :edit, :update, :destroy]

  respond_to :html

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by { |organization| organization.title }
  end

  def index
    if mentorship_circle_params[:organization_id].present?
      unless mentorship_circle_params[:organization_id] == [""]
        @organization =  mentorship_circle_params[:organization_id]
      end
    else
      @organization = current_user.unique_groups
    end

    @mentorship_circles = MentorshipCircle.where(organization_id: @organization)
    respond_with(@mentorship_circles)
  end

  def show
    #@best_practice = MentorshipCircle.find(params[:id])
    @commentable   = @mentorship_circle
    @comments      = @commentable.comments
    @comment       = Comment.new
    @organization  = current_user.organization

    respond_with(@mentorship_circle)
  end

  def new
    @mentorship_circle = MentorshipCircle.new
    respond_with(@mentorship_circle)
  end

  def edit
  end

  def create
    @mentorship_circle = MentorshipCircle.new(mentorship_circle_params[:mentorship_circle])
    @mentorship_circle.mentor = current_user
    @mentorship_circle.save
    respond_with(@mentorship_circle)
  end

  def update
    @mentorship_circle.update_attributes(mentorship_circle_params[:mentorship_circle])
    respond_with(@mentorship_circle)
  end

  def destroy
    @mentorship_circle.destroy
    respond_with(@mentorship_circle)
  end

  def join
    mentorship_circle = MentorshipCircle.find(mentorship_circle_params[:mentorship_circle_id])
    mentorship_circle.users << current_user
    Notifier.mc_join_email(mentorship_circle, current_user).deliver!
    Notifier.mc_mentee_join_email(mentorship_circle, current_user).deliver!
    redirect_to mentorship_circle_path(mentorship_circle.id)
  end

  def leave
    mentorship_circle = MentorshipCircle.find(mentorship_circle_params[:mentorship_circle_id])
    mentorship_circle.users.delete(current_user)
    redirect_to mentorship_circle_path(mentorship_circle.id)
  end

  protected

  def mentorship_circle_params
    # XXX (cmhobbs) considered harmful but so are stupid rails tricks.
    #               see best practices controller for more of this
    #               madness
    params.permit!
    # MentorshipCircle
    #   .permitted(params)
    #   .merge(params.permit(:organization_id, :mentor_action_plan_id, :id))
  end

  private
  
  def set_mentorship_circle
    @mentorship_circle = MentorshipCircle.find(mentorship_circle_params[:id])
  end
end
