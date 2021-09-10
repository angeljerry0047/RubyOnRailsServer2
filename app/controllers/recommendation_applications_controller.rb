class RecommendationApplicationsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @recommendation_application = RecommendationApplication.new(:recommendation_id => params[:recommendation_id])
  end

  # NOTE (cmhobbs) this could benefit from decent_exposure
  def create
    @recommendation_application = RecommendationApplication.new({:recommendation_id => params[:recommendation_id], :user_id => current_user.id})
    @recommendation_application.user = current_user

    if @recommendation_application.save
      redirect_to skills_path, :notice => "Thanks for registering! The post creater has been emailed."
    else
      redirect_to skills_path, :flash => {:error => @recommendation_application.errors.messages.values.join }
    end
  end

  protected

  def recommendation_application_params
    RecommendationApplication.permitted(params).merge(params.permit(:recommendation_id))
  end
end
