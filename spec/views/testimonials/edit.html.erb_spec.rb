require 'spec_helper'

describe "testimonials/edit" do
  
  let(:testimonial) { stub_model(Testimonial) }
  let(:opportunity) { stub_model(Opportunity) }

  before do
    # NOTE (cmhobbs) this seems a little messy
    @testimonial = assign(:testimonial, testimonial)
    assign(:opportunity, opportunity)
  end

  it "renders the edit testimonial form" do
    render

    assert_select "form[action=?][method=?]", testimonial_path(@testimonial), "post" do
      assert_select "input#testimonial_opportunity_id[name=?]", "testimonial[opportunity_id]"
      assert_select "textarea#testimonial_body[name=?]",        "testimonial[body]"
    end
  end
end
