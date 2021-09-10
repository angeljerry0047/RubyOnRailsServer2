# FIXME: (cmhobbs+tyreldenison) placeholder error to clean up uncaught
#       throws.  relocate this
class AssessmentError < StandardError; end

class AssessmentReportsController < ApplicationController
  before_filter :authenticate_user!

  # NOTE: (cmhobbs+tyreldenison) why?
  respond_to :html, :pdf

  def index
    @assessment_reports = AssessmentReport.where(user_id: current_user.id)
    @coupon_uses = current_user.coupon_uses.where(assessment_report_id: nil)
  end

  def share
    @assessment_report = AssessmentReport.find(params[:id])
    authorize! :read, @assessment_report
  end

  def share_with_emails
    @assessment_report = AssessmentReport.find(params[:id])
    authorize! :read, @assessment_report
  end

  def new
    @assessment_report = AssessmentReport.new(
      assessment_id: Assessment.first.id,
      user_id: current_user.id
    )
  end

  def show
    @assessment_report = AssessmentReport.find(params[:id])

    authorize! :read, @assessment_report

    respond_with(@assessment_report) do |f|
      f.html
      f.pdf { send_data AssessmentReportPdf.new(@assessment_report).render }
    end
  end

  def share_with_email
    # NOTE: (cmhobbs+tyreldenison) this should be asynchronous
    if Notifier.assessment(
      params[:emails],
      params[:subject],
      params[:text],
      params[:assessment_report_id]
    ).deliver
      redirect_to AssessmentReport.find(params[:assessment_report_id]), notice: 'Successfully sent e-mail'
    else
      redirect_to share_assessment_report_path(params[:id]),
                  notice: 'Did not complete please try again'
    end
  end

  def create
    report = assessment_reports_params.reject { |k, _v| k == 'user_answers' }

    answers = assessment_reports_params.fetch(:user_answers).map do |_k, v|
      UserAnswer.new({ user_id: current_user.id }.merge(v))
    end

    @assessment_report = AssessmentReport.new(report)
    @assessment_report.user_answers = answers

    if @assessment_report.invalid? || answers.find(&:invalid?)
      render 'new'
    elsif @assessment_report.save
      redirect_to @assessment_report, notice: 'Thanks for taking the Assessment!'
    else
      raise AssessmentError
    end
  end

  def destroy
    @assessment_report = AssessmentReport.find(params[:id])
    @assessment_report.destroy

    respond_to do |format|
      format.html { redirect_to new_assessment_report_path }
      format.json { head :no_content }
    end
  end

  protected

  def assessment_reports_params
    params.require(:assessment_report).permit!
  end
end
