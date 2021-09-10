# FIXME (cmhobbs+tyreldenison) rails should pick this up
require 'points'
include Points

class FeedbacksController < ApplicationController

  before_filter :authenticate_user!

  def index
    @feedbacks = Feedback.all

    respond_to do |format|
      format.html
      format.json { render json: @feedbacks }
    end
  end

  def show
    @feedback = Feedback.find(feedback_params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @feedback }
    end
  end

  def new
    @feedback = Feedback.new
    @opportunity = Opportunity.find(feedback_params[:opportunity_id])

    respond_to do |format|
      format.html
      format.json { render json: @feedback }
    end
  end

  def edit
    @feedback = Feedback.find(feedback_params[:id])
  end

  def create
    @feedback = Feedback.new(feedback_params[:feedback])
    @opportunity = Opportunity.find(@feedback.opportunity_id)

    respond_to do |format|
      if @feedback.save
        Notifier.new_feedback_email(@feedback).deliver_now!
        format.html { redirect_to new_testimonial_path, :flash => {:opportunity_id => @feedback.opportunity_id}, notice: 'Feedback was successfully created.' }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @feedback = Feedback.find(feedback_params[:id])

    respond_to do |format|
      if @feedback.update_attributes(feedback_params[:feedback])
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feedback = Feedback.find(feedback_params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to feedbacks_url }
      format.json { head :no_content }
    end
  end

  protected

  def feedback_params
    Feedback.permitted(params).merge(params.permit(:id, :opportunity_id))
  end
end
