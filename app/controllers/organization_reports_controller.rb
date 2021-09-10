class OrganizationReportsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :pdf

  def share
    @organization_report = OrganizationReport.new
    @organization_report.find(organization_report_params[:id])

    authorize! :manage, @organization_report        
  end  

  def share_with_email
    @organization_report = OrganizationReport.new
    @organization_report.find(organization_report_params[:id])    

    authorize! :manage, @organization_report

    if Notifier.organizationreport(
      organization_report_params[:emails],
      organization_report_params[:subject],
      organization_report_params[:text],
      @organization_report
    ).deliver
      redirect_to organization_report_path(organization_report_params[:id]), :notice => "Successfully sent e-mail"
    else
      redirect_to share_organization_report_path(organization_report_params[:id]), :notice => "Did not complete please try again", only_path => true
    end
  end

  protected

  def organization_report_params
    params.permit(:id, :subject, :text, :emails)
  end

end

