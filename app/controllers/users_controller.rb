class UsersController < ApplicationController
  before_filter :authenticate_user!

  def find   
    @pac = current_pac
    @search = user_params[:searchUser]
    if @search!=nil
      if @search != ''
        @competencies = Competency.where(:name => @search.capitalize) 
        @interest = Interest.where(:name => @search.capitalize)
        if !@competencies.empty?
          @users = User.select{ |u| u.competency_ids.include?(@competencies.first.id)}
        elsif !@interest.empty?
          @users = User.select{ |u| u.interest_ids.include?(@interest.first.id)}  
        else
          @users  = User.joins('LEFT JOIN organizations ON organizations.id=users.organization_id')
          .where('users.name ILIKE ? OR organizations.title ILIKE ? OR users.email ILIKE ?' ,  "%#{@search}%", "%#{@search}%",  "%#{@search}%")
        end
      else
        @users  = nil
      end
    else
      @users  = nil
    end
   
  end

  def manage
    @org = current_user.organization
    @users = @org.users
  end
  
  def update_many
    User.update(user_params[:users].keys, user_params[:users].values)
    flash[:notice] = "Users updated"
    redirect_to skills_path
  end
  
  def show
    @user = User.find(user_params[:id])
    @competencies = []# @user.opportunities.map{|x| x.competencies.map {|c| c.name } }.flatten
    @user_count = User.count
    @groups = @user.user_groups
    @appgroups = @groups.where(approved: true)

    @mentorship_circle    = MentorshipCircle.where(mentor_id: @user.id)
    @collaboration_circle = CollaborationCircle.where(facilitator_id: @user.id)
    @mentorship           = Opportunity.where(owner_id: @user.id, opportunity_category_id: 18)
    @best_practice        = BestPractice.where(user_id: @user.id)
    @pac                  = Pac.where(owner_id: @user.id)
    @fast_content         = FastContent.where(user_id: @user.id)
    @badges               = @user.badges.includes(:badge_type).awardable
    @certifications       = @user.certifications.includes(:certification_type).awardable
  end
  
 
  def historical_opportunities
    @opportunities = current_user.opportunities.past_experience
  end

  def avatars
    Rails.logger.warn("Tombstone 8-3-2015 MK: UsersController#avatars should be a method that is removed please look at in the future")
    user = User.find(user_params[:id])
    send_file user.avatar.path, :type => 'image/jpeg', :disposition => 'inline'
  end


  def index
    # @pac = current_pac
    # @users = User.order(:name)
    # respond_to do |format|
    #   format.csv { render text: @users.to_csv }
    # end
    redirect_to after_sign_in_path_for(current_user)
  end

  protected

  def user_params
    User
      .permitted(params)
      .merge(params.permit(:id, :searchUser))
      .merge(params.permit(users: User.attribute_whitelist))
  end

end
