require "spec_helper"

describe CoachActionPlansController do
  describe "routing" do

    it "routes to #index" do
      get("/coach_action_plans").should route_to("coach_action_plans#index")
    end

    it "routes to #new" do
      get("/coach_action_plans/new").should route_to("coach_action_plans#new")
    end

    it "routes to #show" do
      get("/coach_action_plans/1").should route_to("coach_action_plans#show", :id => "1")
    end

    it "routes to #edit" do
      get("/coach_action_plans/1/edit").should route_to("coach_action_plans#edit", :id => "1")
    end

    it "routes to #create" do
      post("/coach_action_plans").should route_to("coach_action_plans#create")
    end

    it "routes to #update" do
      put("/coach_action_plans/1").should route_to("coach_action_plans#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/coach_action_plans/1").should route_to("coach_action_plans#destroy", :id => "1")
    end

  end
end
