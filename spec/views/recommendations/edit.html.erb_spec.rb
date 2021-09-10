require 'spec_helper'

describe "recommendations/edit" do
  let(:user) { stub_model(User, name: 'test') }

  let(:recommendation) do
    stub_model(Recommendation, id: 1, user_id: 1)
  end

  before(:each) do
    @user = assign(:user, user)
    @recommendation = assign(:recommendation, recommendation)
  end

  it "renders the edit recommendation form" do
    render

    assert_select "form[action=?][method=?]", recommendation_path(@recommendation), "post" do
      assert_select "input#recommendation_user_id[name=?]", "recommendation[user_id]"
    end
  end
end
