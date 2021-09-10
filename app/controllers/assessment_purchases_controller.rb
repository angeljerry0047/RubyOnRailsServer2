# FIXME (cmhobbs+tyreldenison) remove this controller and its related routes
class AssessmentPurchasesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @assessment_purchase = AssessmentPurchase.find(assessment_purchases_params[:id])
    @charge_object = Stripe::Charge.retrieve(:id => @assessment_purchase.charge_id)
    authorize! :read, @assessment_purchase
  end

  def new; end

  def create
    if assessment_purchases_params.has_key?(:stripeToken)
      price = Assessment.find(assessment_purchases_params[:assessment_id]).price * 100

      charge = Stripe::Charge.create(
        :amount => price.to_i,
        :currency => "usd",
        :card => assessment_purchases_params.fetch(:stripeToken), # obtained with Stripe.js
        :description => "Purchase of assessment on Serve2Perform"
      )

      current_user.assessment_purchases << AssessmentPurchase.new(
        :assessment_id => assessment_purchases_params[:assessment_id],
        :charge_id => charge.id
      )
      current_user.save!
      redirect_to assessment_purchase_path(current_user.assessment_purchases.last)
    else
      redirect_to new_assessment_purchase_path(
        :assessment_id => assessment_purchases_params[:assessment_id]
      ), :error => "There was an error processing your transaction please try again"
    end
  end

  protected

  def assessment_purchases_params
    params.permit(:id, :assessment_id, :stripeToken)
  end
end
