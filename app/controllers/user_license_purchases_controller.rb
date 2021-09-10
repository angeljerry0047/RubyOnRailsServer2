# NOTE (cmhobbs) is this necessary still?
class UserLicensePurchasesController < ApplicationController

  before_filter :authenticate_user!

  def show
    @user_license_purchase = UserLicensePurchase.find(user_license_purchase_params[:id])
    @charge_object = Stripe::Charge.retrieve(:id => @user_license_purchase.charge_id)
    authorize! :read, @user_license_purchase
  end

  def new; end

  def create
    if user_license_purchase_params.has_key?(:stripeToken)

      price = 1000 * user_license_purchase_params[:licenses_purchased].to_i

      charge = Stripe::Charge.create(
        :amount => price.to_i,
        :currency => "usd",
        :card => user_license_purchase_params.fetch(:stripeToken), # obtained with Stripe.js
        :description => "Purchase of user licenses on Serve2Perform"
      )

      current_user.user_license_purchases << UserLicensePurchase.new(:licenses_purchased => user_license_purchase_params[:licenses_purchased], :charge_id => charge.id, :organization_id => current_user.organization_id)
      current_user.save!
      @organization = current_user.organization
      @current_licenses = @organization.user_licenses
      @new_license_total = @current_licenses + user_license_purchase_params[:licenses_purchased].to_i
      @organization.update_attributes(:user_licenses => @new_license_total)
      redirect_to user_license_purchase_path(current_user.user_license_purchases.last)
    else
      redirect_to new_user_lisence_purchase_path, :error => "There was an error processing your transaction please try again"
    end
  end

  protected

  def user_license_purchase_params
    params.permit(:id, :licenses_purchased, :stripeToken)
  end

end
