# coding: utf-8
class AccountsController < ApplicationController
  include ApplicationHelper
  
  def generate
    if request.headers["X-Shopify-Shop-Domain"] == "learning-marketplace.myshopify.com"
      generated_password = SecureRandom.hex
      email = account_params.fetch('email')
      billing_address = account_params.fetch("billing_address")
      first_name = billing_address.fetch("first_name")
      last_name = billing_address.fetch("last_name")
      
      user = User.new(
        email:                 email,
        name:                  "#{first_name} #{last_name}",
        password:              generated_password,
        password_confirmation: generated_password,
        via_shopify:           true
      )

      # XXX (cmhobbs) replace this hard coded organization
      # (Serve2Perform) with an environment varible.
      user.organization = Organization.find(257)

      # NOTE (cmhobbs) make a user a hub member if they bought the
      # appropriate package
      # 
      # NOTE (cmhobbs) item["id"] may be more appropriate here
      #
      # FIXME (cmhobbs) move this to an environment variable
      line_items = params.fetch('line_items').map { |item| item["title"] }
      if line_items.include?('Hub')
        user.hub_member = true
      end
      
      if user.save
        # FIXME (cmhobbs) move this to the User model
        Notifier.delay.new_account_email(user.email, user.name, generated_password)
        render json: { status: 'Account Created.' }.to_json
      else
        render json: user.errors, status: 500
      end

    else
      # TODO (cmhobbs) return useful errors here
      render nothing: true, status: :unauthorized
    end
  end

  protected

  def account_params
    params.permit(:email, { billing_address: [:first_name, :last_name], line_items: [:title] })
  end

end
