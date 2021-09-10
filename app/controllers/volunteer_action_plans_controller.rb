require 'points'
include Points

class VolunteerActionPlansController < ApplicationController
  before_filter :authenticate_user!
  # GET /volunteer_action_plans
  # GET /volunteer_action_plans.json
  def index
    @volunteer_action_plans = VolunteerActionPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @volunteer_action_plans }
    end
  end

  # GET /volunteer_action_plans/1
  # GET /volunteer_action_plans/1.json
  def show
    @volunteer_action_plan = VolunteerActionPlan.find(volunteer_action_plan_params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @volunteer_action_plan }
    end
  end

  # GET /volunteer_action_plans/new
  # GET /volunteer_action_plans/new.json
  def new
    @volunteer_action_plan = VolunteerActionPlan.new
    @opportunity_application = OpportunityApplication.joins(:opportunity).where("opportunities.owner_id" => current_user.id).where("complete_plan" => false).where("opportunities.opportunity_category_id" => 21)
    #@recommendation_application = RecommendationApplication.joins(:recommendation).where("recommendations.user_id" => current_user.id).where("complete_plan" => false).where("recommendations.opportunity_category_id" => )
    @opp_rec_app = @opportunity_application #+ @recommendation_application)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @volunteer_action_plan }
    end
  end

  # GET /volunteer_action_plans/1/edit
  def edit
    @volunteer_action_plan = VolunteerActionPlan.find(volunteer_action_plan_params[:id])
  end

  # POST /volunteer_action_plans
  # POST /volunteer_action_plans.json
  def create
    @volunteer_action_plan = VolunteerActionPlan.new(volunteer_action_plan_params[:volunteer_action_plan])
    @volunteer_action_plan.user_id = current_user.id

    if (volunteer_action_plan_params[:volunteer_action_plan][:liason_name]).include?("r")
      (volunteer_action_plan_params[:volunteer_action_plan][:liason_name]).slice! "r"
      @id_num = (volunteer_action_plan_params[:volunteer_action_plan][:liason_name])
      @recommendation = RecommendationApplication.find(@id_num)
      @volunteer_action_plan.recommendation_application_id = @recommendation.id
      @volunteer_action_plan.liason_id = @recommendation.user_id
      @volunteer_action_plan.liason_name = @recommendation.user.name
      @recommendation.update_attributes(:complete_plan => true)
    elsif (volunteer_action_plan_params[:volunteer_action_plan][:liason_name]).include?("o")
      (volunteer_action_plan_params[:volunteer_action_plan][:liason_name]).slice! "o"
      @id_num = (volunteer_action_plan_params[:volunteer_action_plan][:liason_name])
      @opportunity = OpportunityApplication.find(@id_num)
      @volunteer_action_plan.opportunity_application_id = @opportunity.id
      @volunteer_action_plan.liason_id = @opportunity.user_id
      @volunteer_action_plan.liason_name = @opportunity.user.name
      @opportunity.update_attributes(:complete_plan => true)
    end

    respond_to do |format|
      if @volunteer_action_plan.save
        @volunteer_action_plans_users = VolunteerActionPlansUsers.new(:volunteer_action_plan_id => @volunteer_action_plan.id, :user_id => @volunteer_action_plan.user_id, :liason_id => @volunteer_action_plan.liason_id)
        @volunteer_action_plans_users.save
        Points.give_them_an_stakeholder_point(current_user)
        format.html { redirect_to @volunteer_action_plan, notice: 'Volunteer action plan was successfully submitted.' }
        format.json { render json: @volunteer_action_plan, status: :created, location: @volunteer_action_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @volunteer_action_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /volunteer_action_plans/1
  # PUT /volunteer_action_plans/1.json
  def update
    @volunteer_action_plan = VolunteerActionPlan.find(volunteer_action_plan_params[:id])

    respond_to do |format|
      if @volunteer_action_plan.update_attributes(volunteer_action_plan_params[:volunteer_action_plan])
        format.html { redirect_to @volunteer_action_plan, notice: 'Volunteer action plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @volunteer_action_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_action_plans/1
  # DELETE /volunteer_action_plans/1.json
  def destroy
    @volunteer_action_plan = VolunteerActionPlan.find(volunteer_action_plan_params[:id])
    @volunteer_action_plan.destroy

    respond_to do |format|
      format.html { redirect_to volunteer_action_plans_url }
      format.json { head :no_content }
    end
  end

  protected

  def volunteer_action_plan_params
    VolunteerActionPlan.permitted(params).merge(params.permit(:id))
  end
end
