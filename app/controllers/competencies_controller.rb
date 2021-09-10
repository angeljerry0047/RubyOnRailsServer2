class CompetenciesController < ApplicationController
  before_filter :authenticate_user!
  
  def update
    comps = Array(competencies_params.fetch(:user).fetch(:competency_ids)).flatten.uniq
    @competencies = Competency.find(comps)
    
    if current_user.competencies.concat(@competencies)
      redirect_to edit_user_registration_path, :notice => "Successfully added Competencies to your User Profile"
    else
      redirect_to request.referrer, :error => "Something went wrong, please try again."
    end
  end

  protected

  def competencies_params
    Competency
      .permitted(params)
      .merge(User.permitted(params))
      .merge(params.permit(:competency_ids))
  end
end