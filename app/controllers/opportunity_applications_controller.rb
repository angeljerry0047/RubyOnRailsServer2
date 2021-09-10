class OpportunityApplicationsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @opportunity_application = OpportunityApplication.new(opportunity_id: opportunity_applications_params[:opportunity_id])
  end

  def create
    @opportunity_application = OpportunityApplication.new({
                                                            opportunity_id: opportunity_applications_params[:opportunity_id], user_id: current_user.id
                                                          })
    @opportunity_application.user = current_user

    if @opportunity_application.save
      redirect_to root_url, notice: 'Thanks for registering! The post creator has been emailed.'
    else
      redirect_to root_url, flash: { error: @opportunity_application.errors.messages.values.join }
    end
  end

  protected

  def opportunity_applications_params
    OpportunityApplication.permitted(params).merge(params.permit(:opportunity_id))
  end
end
