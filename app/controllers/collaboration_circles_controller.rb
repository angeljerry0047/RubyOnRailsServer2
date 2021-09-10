# FIXME (cmhobbs) use decent_exposure here
class CollaborationCirclesController < ApplicationController
  before_filter :authenticate_user!

  before_filter :set_collaboration_circle, only: [:show, :edit, :update, :destroy]

  respond_to :html

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by { |organization| organization.title }
  end

  def index
    if collaboration_circle_params[:organization_id].present?
     unless collaboration_circle_params[:organization_id] == [""]
      @organization =  collaboration_circle_params[:organization_id]
     end
    else
      @organization = current_user.unique_groups
    end

    @collaboration_circles = CollaborationCircle.where(organization_id: @organization)
    respond_with(@collaboration_circles)
  end

  def show
    @commentable   = @collaboration_circle
    @comments      = @commentable.comments
    @comment       = Comment.new
    @organization  = current_user.organization

    respond_with(@collaboration_circle)
  end

  def new
    @collaboration_circle = CollaborationCircle.new
    respond_with(@collaboration_circle)
  end

  def edit
  end

  def create
    @collaboration_circle = CollaborationCircle.new(collaboration_circle_params[:collaboration_circle])
    @collaboration_circle.facilitator = current_user
    @collaboration_circle.save
    respond_with(@collaboration_circle)
  end

  def update
    @collaboration_circle.update_attributes(collaboration_circle_params[:collaboration_circle])
    respond_with(@collaboration_circle)
  end

  def destroy
    @collaboration_circle.destroy
    respond_with(@collaboration_circle)
  end

  def join
    collaboration_circle = CollaborationCircle.find(collaboration_circle_params[:collaboration_circle_id])
    collaboration_circle.users << current_user
    redirect_to collaboration_circle_path(collaboration_circle.id)
  end

  def leave
    collaboration_circle = CollaborationCircle.find(collaboration_circle_params[:collaboration_circle_id])
    collaboration_circle.users.delete(current_user)
    redirect_to collaboration_circle_path(collaboration_circle.id)
  end

  protected

  def collaboration_circle_params
    CollaborationCircle.permitted(params).merge(params.permit(
      :collaboration_circle_id,
      :organization_id,
      :id
    ))
  end

  private
  
  def set_collaboration_circle
    @collaboration_circle = CollaborationCircle.find(collaboration_circle_params[:id])
  end


end
