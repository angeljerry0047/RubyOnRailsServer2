class CouponUsesController < ApplicationController
  before_filter :authenticate_user!
  def new
    @coupon_use = CouponUse.new
  end

  def create
    code = coupon_use_params.fetch(:coupon_use).fetch(:coupon)

    if Coupon.exists?(:code => code) && Coupon.where(code: code).first.remaining > 0
      @coupon_use = CouponUse.new(
        :user_id => current_user.id,
        :coupon_id => Coupon.where(code: code).first.id
      )

      if @coupon_use.save
        redirect_to new_assessment_report_path
      else
        redirect_to new_coupon_use_path, :notice => @coupon_use.errors
      end
    else
      redirect_to new_coupon_use_path
    end
  end

  protected

  def coupon_use_params
    CouponUse.permitted(params).merge(Coupon.permitted(params))
  end
end
