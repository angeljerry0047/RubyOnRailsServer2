# FIXME (cmhobbs) this shouldn't be necessary, rails picks up lib/
require 'points'
include Points

class CoachActionPlansController < ApplicationController
  before_filter :authenticate_user!

  def index
    @coach_action_plans = CoachActionPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coach_action_plans }
    end
  end

  def show
    @coach_action_plan = CoachActionPlan.find(coach_action_plan_params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coach_action_plan }
    end
  end

  # NOTE (cmhobbs) this is related to the Opportunity model mess
  # NOTE (tyreldenison) this populates an array of "coach" content
  #      associated with a user and passes it as @opp_rec_app for
  #      selection
  def new
    @coach_action_plan = CoachActionPlan.new
    # XXX (cmhobbs) find a Rails way to do this.
    @opportunity_application = OpportunityApplication.joins(:opportunity).where("opportunities.owner_id" => current_user.id).where("complete_plan" => false).where("opportunities.opportunity_category_id" => 18 || 17)
    @recommendation_application = RecommendationApplication.joins(:recommendation).where("recommendations.user_id" => current_user.id).where("complete_plan" => false).where("recommendations.opportunity_category_id" => 1 || 4 || 8 || 10 || 14 || 16)
    @opp_rec_app = (@opportunity_application + @recommendation_application)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coach_action_plan }
    end
  end

  # NOTE (cmhobbs) this, too is related to the Opportunity model mess
  #
  # FIXME (cmhobbs+tyrendenison) decent_exposure would apply here
  def edit
    @opportunity_application = OpportunityApplication.joins(:opportunity).where("opportunities.owner_id" => current_user.id).where("complete_plan" => false).where("opportunities.opportunity_category_id" => 18 || 17)
    @recommendation_application = RecommendationApplication.joins(:recommendation).where("recommendations.user_id" => current_user.id).where("complete_plan" => false).where("recommendations.opportunity_category_id" => 1 || 4 || 8 || 10 || 14 || 16)
    @opp_rec_app = (@opportunity_application + @recommendation_application)

    @coach_action_plan = CoachActionPlan.find(coach_action_plan_params[:id])
  end

  def create
    @coach_action_plan = CoachActionPlan.new(coach_action_plan_params[:coach_action_plan])
    @coach_action_plan.user_id = current_user.id

    # XXX (cmhobbs+tyreldenison) r == recommendation, o == opportunity
    #     these are apparently used as a means of providing a uid.
    #
    # FIXME (cmhobbs+tyreldenison) refactor.
    if (coach_action_plan_params[:coach_action_plan][:participant_name]).include?("r")
      (coach_action_plan_params[:coach_action_plan][:participant_name]).slice! "r"
      @id_num = (coach_action_plan_params[:coach_action_plan][:participant_name])
      @recommendation = RecommendationApplication.find(@id_num)
      @coach_action_plan.recommendation_application_id = @recommendation.id
      @coach_action_plan.participant_id = @recommendation.user_id
      @coach_action_plan.participant_name = @recommendation.user.name
      @participant = @recommendation.user
      @recommendation.update_attributes(:complete_plan => true)
    elsif (coach_action_plan_params[:coach_action_plan][:participant_name]).include?("o")
      (coach_action_plan_params[:coach_action_plan][:participant_name]).slice! "o"
      @id_num = (coach_action_plan_params[:coach_action_plan][:participant_name])
      @opportunity = OpportunityApplication.find(@id_num)
      @coach_action_plan.opportunity_application_id = @opportunity.id
      @coach_action_plan.participant_id = @opportunity.user_id
      @coach_action_plan.participant_name = @opportunity.user.name
      @participant = @opportunity.user
      @opportunity.update_attributes(:complete_plan => true)
    end

    respond_to do |format|
      if @coach_action_plan.save
        @coach_action_plans_users = CoachActionPlansUsers.new(:coach_action_plan_id => @coach_action_plan.id, :user_id => @coach_action_plan.user_id, :participant_id => @coach_action_plan.participant_id)
        @coach_action_plans_users.save
        Points.give_them_an_collaborator_point(@participant)
        format.html { redirect_to user_path(current_user), notice: 'Coach action plan was successfully submitted.' }
        format.json { render json: @coach_action_plan, status: :created, location: @coach_action_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @coach_action_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @coach_action_plan = CoachActionPlan.find(coach_action_plan_params[:id])

    respond_to do |format|
      if @coach_action_plan.update_attributes(coach_action_plan_params[:coach_action_plan])
        format.html { redirect_to user_path(current_user), notice: 'Coach action plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @coach_action_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @coach_action_plan = CoachActionPlan.find(coach_action_plan_params[:id])
    @coach_action_plan.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

  protected

  def coach_action_plan_params
    CoachActionPlan.permitted(params).merge(params.permit(:id))
  end

end
