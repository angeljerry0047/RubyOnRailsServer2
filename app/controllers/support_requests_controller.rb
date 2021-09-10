class SupportRequestsController < ApplicationController
  skip_before_filter :store_location, only: [:new]

  respond_to :html

  def new
    @support_request = SupportRequest.new
    respond_with(@support_request)
  end

  def create
    @support_request = SupportRequest.new(support_request_params)
    @support_request.ip_address = request.remote_ip

    if @support_request.save
      SupportRequestMailer.delay.new_request(@support_request)
      redirect_to session[:previous_url] || root_url
    else
      render :new
    end
  end

  private

  def set_support_request
    @support_request = SupportRequest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def support_request_params
    params.require(:support_request).permit(:description, :email, :ip_address, :issue_time, :name)
  end
end
