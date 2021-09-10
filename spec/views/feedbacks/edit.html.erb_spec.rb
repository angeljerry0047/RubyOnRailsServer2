require 'spec_helper'

describe "feedbacks/edit" do

  let(:owner)                { stub_model(User, name: 'test') }

  # NOTE (cmhobbs+mbindya) this repetition is the result of 
  #      hard-coded values in the form view
  let(:competency0)  { stub_model(Competency, name: 'competency0') }
  let(:competency1)  { stub_model(Competency, name: 'competency1') }
  let(:competency2)  { stub_model(Competency, name: 'competency2') }
  let(:competencies) { [competency0, competency1, competency2] }

  let(:opportunity_category) do
    stub_model(
      OpportunityCategory,
      competencies: competencies
    )
  end

  let(:opportunity) do
    stub_model(
      Opportunity,
      owner: owner, 
      opportunity_category: opportunity_category
    )
  end
  
  let(:feedback) do
    stub_model(
      Feedback,
      opportunity_id: 1,
      creator_id:     1,
      body:           "MyText"
    )
  end

  before(:each) do
    @feedback    = assign(:feedback, feedback)
    @opportunity = assign(:opportunity, opportunity)
  end

  it "renders the edit feedback form" do
    render

    assert_select "form[action=?][method=?]", feedback_path(@feedback), "post" do
      assert_select "input#feedback_opportunity_id[name=?]", "feedback[opportunity_id]"
    end
  end
end