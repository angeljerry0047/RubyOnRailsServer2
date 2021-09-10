# FIXME (cmhobbs+tyreldenison) use decent_exposure here
class AvailabilityController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @opportunity = Opportunity.find(availability_params[:id])
  end

  protected

  def availability_params
    params.permit(:id)
  end
end
