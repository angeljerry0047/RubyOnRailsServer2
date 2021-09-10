class OrganizationsController < ApplicationController
  before_filter :authenticate_user!

  # NOTE: (cmhobbs+tyreldenison) instantiate an opportunity for
  #      app/views/opportunities/_advisor.html.erb
  expose(:opportunity) { Opportunity.new }

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by { |organization| organization.title }
  end

  expose(:group_count) do
    raw_groups      = UserGroup.where(group_id: @organization.id, approved: true)
    mapped_user_ids = []

    raw_groups.map do |user_group|
      if mapped_user_ids.include?(user_group.member_id)
        next
      else
        mapped_user_ids << user_group.member_id
        user_group
      end
    end.compact
  end

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find_by(slug: organization_params[:slug])

    @mentorship_circle    = MentorshipCircle.where(organization_id: @organization.id)
    @collaboration_circle = CollaborationCircle.where(organization_id: @organization.id)
    @opportunity      = Opportunity.where(organization_id: @organization.id)
    @best_practice    = BestPractice.where(organization_id: @organization.id)
    @inquiry          = Inquiry.where(organization_id: @organization.id)
    @fast_content     = FastContent.where(organization_id: @organization.id)
    @posts            = @opportunity + @best_practice + @inquiry + @fast_content + @mentorship_circle + @collaboration_circle
    @posts            = @posts.sort_by { |p| p.created_at }.reverse.paginate(page: params[:page], per_page: 10)

    @orgadmin         = @organization.users.where(role: 'admin')
    @orgmembers       = UserGroup.where(group_id: @organization.id, approved: true).to_a.uniq

    if UserGroup.where(member_id: current_user, group_id: @organization.id, approved: true).count < 1
      redirect_to root_url and return
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def search
    @organization = Organization.find_by(slug: organization_params[:slug])
    @ideas        = BestPractice.where(organization_id: @organization.id)
    @pacs         = Pac.view_public.where(organization_id: @organization.id)
    @questions    = Inquiry.where(organization_id: @organization.id)

    @skills = (@ideas + @pacs + @questions).sort_by { |skill| skill.created_at }

    if organization_params[:text].present?
      @ideas = @ideas.search_full_text(organization_params[:text])
      @questions = @questions.search_full_text(organization_params[:text])

      @skills = (@ideas + @questions).sort_by { |skill| skill.created_at }
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params[:organization])
    @organization.active_license = true

    if @organization.save
      redirect_to organization_path(@organization.slug)
    else
      render 'new'
    end
  end

  def edit
    @organization = Organization.find_by(slug: organization_params[:slug])
    if GroupAdmin.where(admin_id: current_user.id, group_id: @organization.id).count < 1
      redirect_to organization_path(@organization.slug)
    end
  end

  def analytics
    @organization = Organization.find_by(slug: organization_params[:slug])

    @opportunities = Opportunity.where(organization_id: @organization.id)
    @mentorships = Opportunity.where(opportunity_category_id: 18, organization_id: @organization.id,
                                     title: %w[Mentor Mentee])
    @job_shadowing = Opportunity.where(opportunity_category_id: 19, organization_id: @organization.id,
                                       title: ['Job Shadow Sponsor', 'Job Shadow Student'])
    @volunteers = Opportunity.where(opportunity_category_id: 21, organization_id: @organization.id,
                                    title: ['Volunteer', 'Volunteer Opportunity'])
    @board_service = Opportunity.where(opportunity_category_id: 16, organization_id: @organization.id,
                                       title: ['Board Member', 'Board Service Opportunity'])

    @mentorship_circles = MentorshipCircle.where(organization_id: @organization.id)
    @collaboration_circles = CollaborationCircle.where(organization_id: @organization.id)
    @insights = BestPractice.where(organization_id: @organization.id)

    @all_posts = @opportunities + @mentorship_circles + @collaboration_circles + @insights
    # authorize! :manage, @organization
    if GroupAdmin.where(admin_id: current_user.id, group_id: @organization.id).count < 1
      redirect_to organization_path(@organization.slug)
    end

    organization_params[:period] = 'thirty days' unless organization_params.has_key?(:period)
    @this_period = organization_params[:period]

    if @this_period == 'one year'
      @this_period = 'three-hundred sixty-five days'
    elsif @this_period == 'six months'
      @this_period = 'two-hundred fourty days'
    elsif @this_period == 'three months'
      @this_period = 'one-hundred twenty days'
    elsif @this_period == 'one month'
      @this_period = 'thirty days'
    elsif @this_period == 'one week'
      @this_period = 'seven days'
    end

    @last_period = 'sixty days'
    if @this_period == 'seven days'
      @last_period = 'fourteen days'
    elsif @this_period == 'thirty days'
      @last_period = 'sixty days'
    elsif @this_period == 'one-hundred twenty days'
      @last_period = 'two-hundred fourty days'
    elsif @this_period == 'two-hundred fourty days'
      @last_period = 'four-hundred eighty days'
    elsif @this_period == 'three-hundred sixty-five days'
      @last_period = 'seven-hundred thirty days'
    end
  end

  def update
    @organization = Organization.find_by(slug: organization_params[:slug])
    authorize! :manage, @organization
    @organization.attributes = organization_params[:organization]

    if @organization.save
      redirect_to organization_path(@organization.slug)
    else
      render 'edit'
    end
  end

  def sync
    @organization = Organization.find_by(slug: organization_params[:slug])
    authorize! :manage, @organization

    @client = current_user.to_linkedin_client
    if @organization.provider == 'linkedin' && @organization.oid.present?
      @organization_info = @client.company(id: @organization.oid)
      render 'organizations/reconcile_differences'
    else
      @organizations = @client.company_search(@organization.title)
      if @organizations.empty?
        flash[:error] = "Sorry but there are no companies on linked in called #{@organization.title}"
        redirect_to edit_organization_path(@organization.slug)
      else
        render 'organizations/choose_organization'
      end
    end
  end

  def resources
    @organization = Organization.find_by(slug: organization_params[:slug])
    @department = Department.find(organization_params[:department]) if organization_params[:department].present?
    @fast_content = FastContent.new
  end

  def getType
    @data_for_type = OpportunityType.all
    render json: @data_for_type.map { |c| [c.id, c.name] }
  end

  def avatars
    Rails.logger.warn('Tombstone 8-3-2015 MK: This action OrganizationsController#avatars should be deprecated')
    organization = Organization.find_by(slug: organization_params[:slug])
    send_file organization.avatar.path, type: 'image/jpeg', disposition: 'inline'
  end

  def getFacilities
    pac   = Array(organization_params.fetch(:pacs)).first
    state = pac.fetch(:state)
    city  = pac.fetch(:city)

    @data_for_facility = if city == ''
                           Facility.where(state: state).all
                         else
                           Facility.where(state: state, city: city).all
                         end

    render json: @data_for_facility.map { |c| [c.id, c.name] }
  end

  def getAddress
    @data_for_facility = Facility.where(id: organization_params.fetch(:facility_name_dropdown))
    render json: @data_for_facility.map { |c|
                   [c.id, c.address, c.map_location, c.city, c.approval_name, c.approval_mail]
                 }
  end

  def banners
    Rails.logger.warn('Tombstone 8-3-2015: This action OrganizationsController#banners should be deprecated in the future')
    organization = Organization.find_by(slug: organization_params[:slug])
    send_file organization.banner.path, type: 'image/jpeg', disposition: 'inline'
  end

  def sync_linkedin
    @organization = Organization.find_by(slug: organization_params[:slug])
    authorize! :manage, @organization

    @client            = current_user.to_linkedin_client
    @organization_info = @client.company(id: organization_params[:oid])
    @changeset         = LinkedinClient.differences_between(@organization, @organization_info)

    render 'organizations/reconcile_differences'
  end

  # XXX (cmhobbs) this code and its view were copied from RecommendationsController
  #     under duress.
  def find_users
    @organization = Organization.find_by(slug: organization_params[:slug])
    @search = organization_params[:searchUser]
    if !@search.nil?
      if @search != ''
        # XXX (cmhobbs) none of this db nonsense in the controllers, please
        @users  = User.joins('LEFT JOIN organizations ON organizations.id=users.organization_id')
                      .where('users.name ILIKE ? OR organizations.title ILIKE ?', "%#{@search}%", "%#{@search}%")
      else
        @users  = nil
      end
    else
      @users = nil
    end
  end

  def add_users
    @organization = Organization.find_by(slug: organization_params[:slug])
    @user_ids = organization_params[:user_ids]

    if @user_ids.nil?
      flash[:error] = 'No users were selected'
      redirect_to findUsers_organization_path(@organization.slug) and return
    end

    @user_ids.each do |user_id|
      if UserGroup.where(member_id: user_id, group_id: @organization.id).empty?
        UserGroup.create(member_id: user_id, group_id: @organization.id, approved: true)
      end
    end

    redirect_to organization_path(@organization.slug)
  end

  def leave
    user_group = UserGroup.where(member_id: organization_params[:member_id],
                                 group_id: organization_params[:group_id]).first
    organization = Organization.find(organization_params[:group_id])
    user_group.destroy

    redirect_to organization_path(organization&.slug)
  end

  protected

  def organization_params
    Organization
      .permitted(params)
      .merge(Department.permitted(params))
      .merge(params.permit(pacs: Pac.attribute_whitelist))
      .merge(params.permit(user_ids: []))
      .merge(
        params.permit(
          :city,
          :facility_name_dropdown,
          :group_id,
          :id,
          :member_id,
          :period,
          :searchUser,
          :state,
          :text,
          :slug
        )
      )
  end
end
