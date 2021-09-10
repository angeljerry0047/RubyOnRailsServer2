require 'spec_helper'

describe "testimonials/index" do
  before(:each) do
    assign(:testimonials, [
      stub_model(Testimonial,
        :opportunity_id => 1,
        :creator_id => 2,
        :approved => false,
        :body => "MyText"
      ),
      stub_model(Testimonial,
        :opportunity_id => 1,
        :creator_id => 2,
        :approved => false,
        :body => "MyText"
      )
    ])
  end

  it "renders a list of testimonials" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
