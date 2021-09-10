require "spec_helper"

describe VolunteerActionPlansController do
  describe "routing" do

    it "routes to #index" do
      get("/volunteer_action_plans").should route_to("volunteer_action_plans#index")
    end

    it "routes to #new" do
      get("/volunteer_action_plans/new").should route_to("volunteer_action_plans#new")
    end

    it "routes to #show" do
      get("/volunteer_action_plans/1").should route_to("volunteer_action_plans#show", :id => "1")
    end

    it "routes to #edit" do
      get("/volunteer_action_plans/1/edit").should route_to("volunteer_action_plans#edit", :id => "1")
    end

    it "routes to #create" do
      post("/volunteer_action_plans").should route_to("volunteer_action_plans#create")
    end

    it "routes to #update" do
      put("/volunteer_action_plans/1").should route_to("volunteer_action_plans#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/volunteer_action_plans/1").should route_to("volunteer_action_plans#destroy", :id => "1")
    end

  end
end
