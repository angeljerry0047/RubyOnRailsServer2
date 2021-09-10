require 'spec_helper'

describe "testimonials/show" do
  before(:each) do
    @testimonial = assign(:testimonial, stub_model(Testimonial,
      :opportunity_id => 1,
      :creator_id => 2,
      :approved => false,
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/false/)
    rendered.should match(/MyText/)
  end
end
