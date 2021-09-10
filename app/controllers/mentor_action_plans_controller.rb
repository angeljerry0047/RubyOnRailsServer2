# FIXME (cmhobbs+tyreldenison) rails should pick this up
require 'points'
include Points

# FIXME (cmhobbs+tyreldenison) remove this controller and its routes
class MentorActionPlansController < ApplicationController
  before_filter :authenticate_user!

  def index
    @mentor_action_plans = MentorActionPlan.all

    respond_to do |format|
      format.html
      format.json { render json: @mentor_action_plans }
    end
  end

  def show
    @mentor_action_plan = MentorActionPlan.find(mentor_action_plan_params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @mentor_action_plan }
    end
  end

  def new
    @mentor_action_plan = MentorActionPlan.new
    @opportunity_application = OpportunityApplication.joins(:opportunity).where("opportunities.owner_id" => current_user.id).where("complete_plan" => false).where("opportunities.opportunity_category_id" => 17)
    @recommendation_application = RecommendationApplication.joins(:recommendation).where("recommendations.user_id" => current_user.id).where("complete_plan" => false).where("recommendations.opportunity_category_id" => 4)
    @opp_rec_app = (@opportunity_application + @recommendation_application)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mentor_action_plan }
    end
  end

  # GET /mentor_action_plans/1/edit
  def edit
    @mentor_action_plan = MentorActionPlan.find(mentor_action_plan_params[:id])
  end

  # POST /mentor_action_plans
  # POST /mentor_action_plans.json
  def create
    @mentor_action_plan = MentorActionPlan.new(mentor_action_plan_params[:mentor_action_plan])
    @mentor_action_plan.user_id = current_user.id

    if (mentor_action_plan_params[:mentor_action_plan][:participant_name]).include?("r")
      (mentor_action_plan_params[:mentor_action_plan][:participant_name]).slice! "r"
      @id_num = (mentor_action_plan_params[:mentor_action_plan][:participant_name])
      @recommendation = RecommendationApplication.find(@id_num)
      @mentor_action_plan.recommendation_application_id = @recommendation.id
      @mentor_action_plan.participant_id = @recommendation.user_id
      @mentor_action_plan.participant_name = @recommendation.user.name
      @participant = @recommendation.user
      @recommendation.update_attributes(:complete_plan => true)
    elsif (mentor_action_plan_params[:mentor_action_plan][:participant_name]).include?("o")
      (mentor_action_plan_params[:mentor_action_plan][:participant_name]).slice! "o"
      @id_num = (mentor_action_plan_params[:mentor_action_plan][:participant_name])
      @opportunity = OpportunityApplication.find(@id_num)
      @mentor_action_plan.opportunity_application_id = @opportunity.id
      @mentor_action_plan.participant_id = @opportunity.user_id
      @mentor_action_plan.participant_name = @opportunity.user.name
      @participant = @opportunity.user
      @opportunity.update_attributes(:complete_plan => true)
    end

    respond_to do |format|
      if @mentor_action_plan.save
        @mentor_action_plans_users = MentorActionPlansUsers.new(:mentor_action_plan_id => @mentor_action_plan.id, :user_id => @mentor_action_plan.user_id, :participant_id => @mentor_action_plan.participant_id)
        @mentor_action_plans_users.save
        Points.give_them_an_collaborator_point(@participant)
        Points.give_them_an_mentor_point(current_user)
        format.html { redirect_to user_path(current_user.id), notice: 'Mentor action plan was successfully submitted.' }
        format.json { render json: @mentor_action_plan, status: :created, location: @mentor_action_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @mentor_action_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mentor_action_plans/1
  # PUT /mentor_action_plans/1.json
  def update
    @mentor_action_plan = MentorActionPlan.find(mentor_action_plan_params[:id])

    respond_to do |format|
      if @mentor_action_plan.update_attributes(mentor_action_plan_params[:mentor_action_plan])
        format.html { redirect_to user_path(current_user.id), notice: 'Mentor action plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mentor_action_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mentor_action_plans/1
  # DELETE /mentor_action_plans/1.json
  def destroy
    @mentor_action_plan = MentorActionPlan.find(mentor_action_plan_params[:id])
    @mentor_action_plan.destroy

    respond_to do |format|
      format.html { redirect_to mentor_action_plans_url }
      format.json { head :no_content }
    end
  end

  protected

  def mentor_action_plan_params
    MentorActionPlan.permitted(params).merge(params.permit(:id))
  end

end
