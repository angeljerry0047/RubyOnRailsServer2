require "spec_helper"

describe TestimonialsController do
  describe "routing" do

    it "routes to #index" do
      get("/testimonials").should route_to("testimonials#index")
    end

    it "routes to #new" do
      get("/testimonials/new").should route_to("testimonials#new")
    end

    it "routes to #show" do
      get("/testimonials/1").should route_to("testimonials#show", :id => "1")
    end

    it "routes to #edit" do
      get("/testimonials/1/edit").should route_to("testimonials#edit", :id => "1")
    end

    it "routes to #create" do
      post("/testimonials").should route_to("testimonials#create")
    end

    it "routes to #update" do
      put("/testimonials/1").should route_to("testimonials#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/testimonials/1").should route_to("testimonials#destroy", :id => "1")
    end

  end
end
