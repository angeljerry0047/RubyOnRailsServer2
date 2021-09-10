require 'spec_helper'

describe AssessmentReportPdf do
  let(:assessment_report) { FactoryBot.create(:assessment_report) }

  it 'should be able to render a pdf' do
    @pdf = AssessmentReportPdf.new(assessment_report)
    @pdf.render.should_not be_nil
  end
end
