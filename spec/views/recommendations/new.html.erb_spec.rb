require 'spec_helper'

describe "recommendations/new" do

  let(:recommendation) { stub_model(Recommendation).as_new_record }
  let(:user)           { stub_model(User) }

  before(:each) do
    assign(:recommendation, recommendation)
    assign(:user, user)
  end

  it "renders new recommendation form" do
    render

    assert_select "form[action=?][method=?]", recommendations_path, "post" do
      assert_select "input#recommendation_user_id[name=?]", "recommendation[user_id]"
    end
  end
end
