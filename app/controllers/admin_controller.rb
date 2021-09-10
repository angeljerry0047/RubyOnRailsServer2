class AdminController < ApplicationController

  before_filter :authenticate_user!

  # NOTE (cmhobbs+tyreldenison) wtf is this?
  expose(:facility) { Facility.find(1) }

  def index
    authorize! :read, facility
  end

  # FIXME (cmhobbs+tyreldenison) remove this action and its corresponding route
  def scholarship_request
    @opportunity_scholarships = OpportunityScholarship.where(:opportunity_scholarship_states_id => 1)
    authorize! :read, @opportunity_scholarships 

    if admin_params[:event] == 'accepted'
      @opportunity_scholarship = @opportunity_scholarships.where(id: admin_params[:id]).first
      @opportunity_scholarship.opportunity_scholarship_states_id = 2
      @opportunity_scholarship.approval_user_id = current_user.id
      @opportunity = Opportunity.find(@opportunity_scholarship.opportunity_id)

      if @opportunity_scholarship.save

        @opportunities_users = OpportunitiesUser.new(:opportunity_id => @opportunity.id)
        @opportunities_users.user = current_user
        @opportunities_users.save
        @opportunities_users.each do |ou|
          CompetenciesUser.new(:user_id => ou.id)
        end

        @opportunity_application = OpportunityApplication.new(
          :opportunity_id => @opportunity_scholarship.opportunity_id,
          :user_id => @opportunity_scholarship.user_id,
          :reason_to_apply => @opportunity_scholarship.reason_to_apply,
          :opportunity_applications_type_id => 2,
          :foreign_key => @opportunity_scholarship.id
        )
        
        if @opportunity_application.save
          Notifier.scholarship_acceptance(@opportunity_scholarship).deliver_now!
          redirect_to :back, :notice => "The Scholarship has been accepted."
        else
          redirect_to :back, :flash => {:error => @opportunity_application.errors.messages.values.join }  
        end

      else
        redirect_to :back, :flash => {:error => @opportunity_scholarship.errors.messages.values.join }
      end

    elsif admin_params[:event] == 'rejected'
      @opportunity_scholarship = @opportunity_scholarships.where(id: admin_params[:id]).first
      @opportunity_scholarship.opportunity_scholarship_states_id = 3
      @opportunity_scholarship.approval_user_id = current_user.id

      if @opportunity_scholarship.save
        Notifier.scholarship_rejected(@opportunity_scholarship).deliver_now!
        redirect_to :back, :notice => "The Scholarship has been rejected."
      else
        redirect_to :back, :flash => {:error => @opportunity_scholarship.errors.messages.values.join }
      end      

    end

  end

  protected

  def admin_params
    params.permit(:id, :event)
  end
end
