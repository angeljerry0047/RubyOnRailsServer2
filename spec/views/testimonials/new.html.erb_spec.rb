require 'spec_helper'
describe "testimonials/new" do

  let(:testimonial) { stub_model(Testimonial).as_new_record }
  let(:opportunity) { stub_model(Opportunity) }

  before do
    assign(:testimonial, testimonial)
    assign(:opportunity, opportunity)
  end

  it "renders new testimonial form" do
    render

    # FIXME (cmhobbs) we should break this down into three tests
    assert_select "form[action=?][method=?]", testimonials_path, "post" do
      assert_select "input#testimonial_opportunity_id[name=?]", "testimonial[opportunity_id]"
      assert_select "textarea#testimonial_body[name=?]",        "testimonial[body]"
    end
  end
end
