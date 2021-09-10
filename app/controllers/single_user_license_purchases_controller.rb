# NOTE (cmhobbs) is this still needed?
class SingleUserLicensePurchasesController < ApplicationController

  before_filter :authenticate_user!

  def show
    @single_user_license_purchase = SingleUserLicensePurchase.find(single_user_license_purchase_params[:id])
    @charge_object = Stripe::Charge.retrieve(:id => @single_user_license_purchase.charge_id)
    authorize! :read, @single_user_license_purchase
  end

  def new; end

  def create
    if single_user_license_purchase_params.has_key?(:stripeToken)


      charge = Stripe::Charge.create(
        :amount => 1999,
        :currency => "usd",
        :card => single_user_license_purchase_params.fetch(:stripeToken), # obtained with Stripe.js
        :description => "Purchase of user license on Serve2Perform"
      )

      current_user.single_user_license_purchases << SingleUserLicensePurchase.new(:charge_id => charge.id)
      current_user.save!
      current_user.update_attributes(:active_license => true)
      redirect_to single_user_license_purchase_path(current_user.single_user_license_purchases.last)
    else
      redirect_to new_single_user_license_purchase_path(:assessment_id => single_user_license_purchase_params[:assessment_id]), :error => "There was an error processing your transaction please try again"
    end
  end

  protected

  def single_user_license_purchase_params
    SingleUserLicensePurchase.permitted(params).merge(
      params.permit(:assessment_id, :stripeToken)
    )
  end
end
