class HomeController < ApplicationController

  expose(:top_five) { BestPractice.top_ten[0..4] }
  expose(:org_name)  { current_user.organization.title }
  
  def index
    if user_signed_in?
      redirect_to user_path(current_user.id, protocol: 'https')
    else
      @recent_activity = latest_content_for(257)
      render :layout => 'home'  # app/views/layouts/home.html.erb
    end
  end

  def download 
    send_data pdf,
      :filename => "White_Paper.pdf",
      :type => "application/pdf"
  end

  private

  # FIXME (cmhobbs) clean this up and find a good home for it.
  # NOTE  (cmhobbs) this is very explicit due to sorting issues
  def latest_content_for(organization_id, limit=10)
    organization = Organization.find(organization_id)

    mentorships   = OpportunityCategory.find(18).opportunities.where(organization_id: organization_id).order(:created_at)
    job_shadowing = OpportunityCategory.find(19).opportunities.where(organization_id: organization_id).order(:created_at)
    volunteerism  = OpportunityCategory.find(21).opportunities.where(organization_id: organization_id).order(:created_at)

    best_practices        = organization.best_practices.order(:created_at)
    mentorship_circles    = organization.mentorship_circles.order(:created_at)
    collaboration_circles = organization.collaboration_circles.order(:created_at)

    all_posts = mentorships + job_shadowing + volunteerism + best_practices + mentorship_circles + collaboration_circles

    all_posts.sort_by { |post| post.created_at.to_date.to_s }.reverse.first(limit).reverse
  end

end
