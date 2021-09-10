# FIXME (cmhobbs+tyreldenison) remove this controller and its routes
class OpportunityScholarshipsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @opportunity_scholarship = OpportunityScholarship.new(:opportunity_id => opportunity_scholarship_params[:opportunity_id])
  end

  def create
    @opportunity_scholarship      = OpportunityScholarship.new(opportunity_scholarship_params[:opportunity_scholarship])
    @opportunity_scholarship.user = current_user

    if @opportunity_scholarship.save
      redirect_to skills_path, :notice => "Thanks for Scholarship! It has been emailed to the skill Creator."
    else
      redirect_to skills_path, :flash => {:error => @opportunity_scholarship.errors.messages.values.join }
    end
  end

  protected

  def opportunity_scholarship_params
    OpportunityScholarship.permitted(params).merge(params.permit(:opportunity_id))
  end
end
