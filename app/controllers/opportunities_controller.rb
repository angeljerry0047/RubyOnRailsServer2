class OpportunitiesController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :opportunity, :title, scopes: [:external]

  expose(:public_opportunities) { Opportunity.non_historical_active.where(internal: false).order('title') }

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by { |organization| organization.title }
  end

  def index
    if opportunities_params[:opportunity_category_id].present?
      unless opportunities_params[:opportunity_category_id] == ['']
        @category = opportunities_params[:opportunity_category_id]
      end
    else
      @category = nil
    end

    if opportunities_params[:organization_id].present?
      @organization = opportunities_params[:organization_id] unless opportunities_params[:organization_id] == ['']
    else
      @organization = current_user.unique_groups
    end

    @competencies = Competency.where(id: opportunities_params[:competency_ids])
    @category = OpportunityCategory.where(id: opportunities_params[:opportunity_category_id])
    @category_name = OpportunityCategory.find(opportunities_params[:opportunity_category_id]).name
    if @category_name == 'Advisor'
      @category_name_converted = 'mentorship'
    elsif @category_name == 'Volunteer'
      @category_name_converted = 'volunteer'
    elsif @category_name == 'Internship'
      @category_name_converted = 'job shadowing'
    end

    @opportunities = Opportunity.where(organization_id: @organization, opportunity_category_id: @category)
    @recommendations = Recommendation.where(user_id: UserGroup.where(group_id: @organization),
                                            opportunity_category_id: @category)

    # XXX (cmhobbs) this is likely broken with the removal of the Zip
    #     model.  Geospatial data has not been used in years for s2p
    #     and this should be considered deprecated.
    # if opportunities_params[:zipcode] =~ /^\d{5}(-\d{4})?$/ && opportunities_params[:miles]
    #   public_opportunities = public_opportunities.within(opportunities_params[:zipcode], opportunities_params[:miles])
    # end

    if !!opportunities_params[:internal_only]
      public_opportunities = public_opportunities.within_organization(current_user.organization)
    end

    public_opportunities = public_opportunities.with_competencies(@competencies) unless @competencies.empty?

    if opportunities_params[:text].present?
      public_opportunities = public_opportunities.search_full_text(opportunities_params[:text])
    end
  end

  def edit
    @opportunity = Opportunity.find(opportunities_params[:id])
    authorize! :manage, @opportunity
    @oppotunity_categories = OpportunityCategory.order('name')
    @oppotunity_types = OpportunityType.order('id')
    @type = @opportunity.opportunity_category.name
    @learning_objectives = @opportunity.learning_objectives
  end

  def edit_many
    @past_opportunities    = current_user.past_opportunities
    @owned_opportunities   = current_user.current_opportunities
    @oppotunity_categories = OpportunityCategory.order('name')
    @oppotunity_types      = OpportunityType.order('id')
  end

  def show
    if Opportunity.where(id: opportunities_params[:id]).exists?
      @opportunity = Opportunity.find(opportunities_params[:id])

      @category_name = OpportunityCategory.find(@opportunity.opportunity_category_id).name
      if @category_name == 'Advisor'
        @category_name_converted = 'mentorship'
      elsif @category_name == 'Volunteer'
        @category_name_converted = 'volunteer'
      elsif @category_name == 'Internship'
        @category_name_converted = 'job shadowing'
      end
    else
      flash[:notice] = "The opportunity you're looking for has been deleted"
      redirect_to root_url
    end
  end

  def new
    if opportunities_params[:organization_id].present?
      @organization_id = opportunities_params[:organization_id] unless opportunities_params[:organization_id] == ['']
    else
      @organization_id = nil
    end

    @type                      = opportunities_params[:type]
    @best_practice_category_id = opportunities_params[:category_id]
    @opportunity               = Opportunity.new
    @oppotunity_categories     = OpportunityCategory.order('name')
    @oppotunity_types          = OpportunityType.order('id')

    @type = opportunities_params[:type] || 'advisor'

    if opportunities_params[:opportunity_id]
      @opportunity_trade = Opportunity.find(opportunities_params[:opportunity_id])
      flash[:notice]     = 'Post a new skill and your registration will be complete.'
    elsif opportunities_params[:recommendation_id]
      @recommendation_trade = Recommendation.find(opportunities_params[:recommendation_id])
      flash[:notice]        = "Post a new skill to contact this #{@recommendation_trade.opportunity_category.name}."
    end
  end

  def approved
    opportunity = Array(opportunities_params.fetch(:opportunities)).first
    Notifier.new_opportunity_email(self, opportunity).deliver_now! if oportunity[:approval_status] == true
  end

  # XXX (cmhobbs+tyreldenison) refactor.
  def update
    @opportunity = Opportunity.find(opportunities_params[:id])
    # FIXME: (cmhobbs) should we include organization_id here?
    @opportunity.title               = opportunities_params[:opportunity][:title]
    @opportunity.description         = opportunities_params[:opportunity][:description]
    @opportunity.learning_objectives = opportunities_params[:opportunity][:learning_objectives]
    @opportunity.location            = opportunities_params[:location]
    @opportunity.start_date          = opportunities_params[:start_date]
    @opportunity.deadline_date       = opportunities_params[:deadline_date]
    @opportunity.meeting_time        = opportunities_params[:meeting_time]
    @opportunity.min_students        = opportunities_params[:min_students]
    @opportunity.max_students        = opportunities_params[:max_students]
    @opportunity.save
    redirect_to opportunity_path(@opportunity)
  end

  def create
    @opportunity = Opportunity.new(opportunities_params[:opportunity])
    @opportunity.owner = current_user
    @opportunity.save
    redirect_to opportunity_path(@opportunity)
  end

  def update_many
    opportunities = opportunities_params.fetch(:opportunities) { [] }
    public_opportunities = []

    opportunities.each do |opportunity_hash|
      next if opportunity_hash.delete(:ghost) == 'true'

      opportunity_hash.delete(:ghost)
      opp = Opportunity.find_or_initialize_by_id(opportunity_hash.delete(:id))
      opp.attributes = opportunity_hash
      opp.save!
      public_opportunities << opp
    end

    if public_opportunities.find_index(&:invalid?)
      render 'users/historical_opportunities'
    else
      current_user.opportunities = public_opportunities
      current_user.save!
      redirect_to user_path(current_user.id), notice: 'Updated your skill history!'
    end
  end

  def destroy
    Opportunity.find(opportunities_params[:id]).destroy
    redirect_to root_url
  end

  def getFacilities
    opportunity = Array(opportunities_params.fetch(:opportunities)).first
    state       = opportunity.fetch(:state)
    city        = opportunity.fetch(:city)

    @data_for_facility = if city == ''
                           Facility.where(state: state).all
                         else
                           Facility.where(state: state, city: city).all
                         end

    render json: @data_for_facility.map { |c| [c.id, c.name] }
  end

  def getAddress
    @data_for_facility = Facility.where(id: opportunities_params.fetch(:facility_name_dropdown))
    render json: @data_for_facility.map { |c|
                   [c.id, c.address, c.map_location, c.city, c.approval_name, c.approval_mail]
                 }
  end

  def getPrice
    opportunity = Array(opportunities_params.fetch(:opportunities)).first
    @data_for_category = OpportunityCategory.where(id: opportunity.fetch(:opportunity_category_id)).all
    render json: @data_for_category.map { |c| [c.id, c.price] }
  end

  def getType
    @data_for_type = OpportunityType.all
    render json: @data_for_type.map { |c| [c.id, c.name] }
  end

  def register_pde
    @opportunity = Opportunity.find(opportunities_params[:id])
  end

  # FIXME: (cmhobbs+tyreldenison) remove this action and its route
  def oneClickRegister
    @in_person_id = 320
    @opportunity_application = OpportunityApplication.new(opportunity_id: @in_person_id,
                                                          user_id: current_user.id, reason_to_apply: '', opportunity_applications_type_id: 3)
    @opportunity = Opportunity.find(@in_person_id)
    @opportunity_application.save!
    if @opportunity_application.save!
      public_opportunities_users = OpportunitiesUser.new(opportunity_id: @in_person_id)
      public_opportunities_users.user = current_user
      public_opportunities_users.save
      public_opportunities_users.each do |ou|
        CompetenciesUser.new(user_id: ou.id)
      end
      redirect_to root_url,
                  notice: 'Your registration for the speaker series is complete. You can now continue to explore additional skills.'
    end
  end

  protected

  def opportunities_params
    Opportunity
      .permitted(params)
      .merge(params.permit(opportunities: Opportunity.attribute_whitelist))
      .merge(
        params.permit(
          :category_id,
          :deadline_date,
          :id,
          :facility_name_dropdown,
          :location,
          :max_students,
          :meeting_time,
          :miles,
          :min_students,
          :opportunity_category_id,
          :organization_id,
          :recommendation_id,
          :start_date,
          :text,
          :type,
          :zipcode
        )
      )
  end
end
