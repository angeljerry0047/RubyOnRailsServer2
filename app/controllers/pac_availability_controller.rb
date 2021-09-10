class PacAvailabilityController < ApplicationController
  
  before_filter :authenticate_user!

  def show
    @pac               = Pac.find(pac_availability_params[:id])
    @pacpage           = true
    # NOTE (cmhobbs) is this still being used?
    @pac.approval_code = ""
  end

  def edit
    @pac     = Pac.find(pac_availability_params[:id])
    @pacpage = true
  end

  protected

  def pac_availability_params
    Pac.permitted(params).merge(params.permit(:id))
  end
end
