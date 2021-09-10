# FIXME: (cmhobbs) this is unnecessary.  rails should grab lib/points.rb automagically.
require 'points'
include Points

class PacsController < ApplicationController
  before_filter :authenticate_user!

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by { |organization| organization.title }
  end

  def index
    if pac_params[:organization_id].present?
      @organization = pac_params[:organization_id] unless pac_params[:organization_id] == ['']
    else
      @organization = current_user.unique_groups
    end

    @pacs = Pac.where(organization_id: @organization)
  end

  def new
    if current_user.active_license == true
      if @pac.nil? && current_pac.empty?

        @pac = Pac.new
        @pacpage = true
        @opportunity_type = OpportunityType.order('id')
        @best_practice_category_id = pac_params[:category_id]
        unless @best_practice_category_id.nil?
          @best_practice_category = BestPracticeCategory.find(@best_practice_category_id)
        end

        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @pac }
        end
      else
        respond_to do |format|
          format.html { redirect_to find_users_path, notice: 'There is a collaboration team currently in progress.' }
          format.json { render json: @pac }
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_to new_single_user_license_purchase_path,
                      notice: 'You need an active license to access this feature.'
        end
      end
    end
  end

  def create
    pac = Array(pac_params.fetch(:pacs)).first

    # XXX (cmhobs) what is this doing?  why are the strings 'id' and
    #     'ghost' relevant?
    @pac = Pac.new(pac.reject { |k, _| %w[id ghost].include?(k) })

    @pac.in_progress     = true
    @pac.approval_code   = Array.new(6) { rand(36).to_s(36) }.join
    @pac.organization_id = current_user.organization_id

    @pac[:best_practice_category_id] = (pac_params[:pac][:best_practice_category_id]).to_i

    # XXX (cmhobbs) why are we checking static ids here?  don't do this.
    @pac.approval_status = true if @pac.opportunity_type_id == 5

    if @pac.got_point == false
      Points.give_them_an_collaborator_point(@pac.owner)
      @pac.update_attributes(got_point: true)
    end

    respond_to do |format|
      if @pac.save
        format.html { redirect_to find_users_path, notice: 'Collaboration team was successfully created.' }
        format.json { render json: @pac, status: :created, location: @pac }
      else
        format.html { render action: 'new' }
        format.json { render json: @pac.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @pac              = Pac.find(pac_params[:id])
    @pacpage          = true
    @opportunity_type = OpportunityType.order('id')
    @users            = @pac.pac_members.each_slice(4).to_a
    @mobileusers      = @pac.pac_members.each_slice(2).to_a
    @cancel_pac       = current_pac
  end

  # XXX (cmhobbs) params used as flow control, deeply nested branching
  #     logic, multiple objects being updated that are not the focus
  #     of the controller.  this is the stuff of nightmares.
  def update
    if pac_params[:commit] == 'Verify'
      pac = pac_params.fetch(:pac)
      @pac = Pac.where(
        approval_code: pac[:approval_code],
        id: pac_params.fetch(:id)
      ).first
      if @pac.nil?
        redirect_to pac_availability_path(pac_params.fetch(:id)), flash: { error: 'Please enter a valid code' }
      else
        redirect_to edit_pac_availability_path, notice: 'Your code is correct'
      end
    elsif pac_params[:commit] == 'Confirm'
      pac = pac_params.fetch(:pac)
      @pac = Pac.find(pac_params.fetch(:id))
      @pac.update_attributes(webcast_id: pac[:webcast_id])
      @pac.update_attributes(webcast_facilitator_id: pac[:webcast_facilitator_id])
      if @pac.update_attributes!({ approval_status: true })
        # FIXME: (cmhobbs) change this to asynch delivery
        Notifier.confirm_pac_availability(@pac).deliver_now!
        if @pac.got_point == false
          Points.give_them_an_collaborator_point(@pac.owner)
          @pac.update_attributes(got_point: true)
        end
        @pac.pac_members.each do |member|
          # FIXME: (cmhobbs) change this to asynch delivery
          Notifier.new_pac_email(member, @pac).deliver_now!
        end
        redirect_to root_url, notice: 'Successfully approved collaboration team request'
      else
        redirect_to pac_availability_path,
                    flash: { error: 'There was an error approving your collaboration team request' }
      end
    elsif pac_params[:commit] == 'Reject'
      @pac = Pac.find(pac_params.fetch(:id))
      if @pac.update_attributes!({ approval_status: false })
        # FIXME: (cmhobbs) change this to asynch delivery
        Notifier.reject_pac_availability(@pac).deliver_now!
        redirect_to root_url, notice: 'Successfully rejected the collaboration team request'
      else
        redirect_to pac_availability_path,
                    flash: { error: 'There was an error rejecting your collaboration team request' }
      end
    else

      pac = Array(pac_params.fetch(:pacs)).first
      @pac = Pac.find(pac.fetch(:id))
      @pac.update_attributes(in_progress: nil)
      @pac.update_attributes(complete: true)
      if pac[:is_public].present?
        @pac.update_attributes(is_public: true)
      else
        @pac.update_attributes(is_public: false)
      end
      if @pac.facility.blank? || @pac.facility.approval_name.blank? || @pac.facility.approval_mail.blank?
        @pac.approval_status = true
        @pac.pac_members.each do |member|
          # FIXME: (cmhobbs) change this to asynch delivery
          Notifier.new_pac_email(member, @pac).deliver_now!
        end
      end
      @oppotunity_categories = OpportunityCategory.order('name')
      if @pac.update_attributes(pac.reject { |k, _| %w[id ghost].include?(k) })
        redirect_to pac_path(@pac.id), notice: 'Successfully updated collaboration team'
      else
        render 'edit'
      end
    end
  end

  def show
    @pac         = Pac.find(pac_params[:id])
    @pac_show    = Pac.where(in_progress: 'true')
    @pacpage     = true
    @commentable = @pac
    @comments    = @commentable.comments
    @comment     = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pac }
    end
  end

  def getFacilities
    pac   = Array(pac_params.fetch(:pacs)).first
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
    @data_for_facility = Facility.where(id: pac_params.fetch(:facility_name_dropdown))
    render json: @data_for_facility.map { |c|
                   [c.id, c.address, c.map_location, c.city, c.approval_name, c.approval_mail]
                 }
  end

  def getType
    @data_for_type = OpportunityType.all
    render json: @data_for_type.map { |c| [c.id, c.name] }
  end

  def cancel
    pac = Pac.find(pac_params[:id])
    pac.destroy

    redirect_to find_users_path, notice: 'Collaboration team was successfully canceled.'
  end

  def destroy
    pac = Pac.find(pac_params[:id])
    pac.destroy

    redirect_to user_path(current_user), notice: 'Collaboration team was successfully canceled.'
  end

  protected

  def pac_params
    Pac
      .permitted(params)
      .merge(Facility.permitted(pac_params))
      .merge(params.permit(pacs: Pac.attribute_whitelist))
      .merge(params.permit(
               :approval_code,
               :category_id,
               :city,
               :commit,
               :facility_name_dropdown,
               :id,
               :is_public,
               :organization_id,
               :state,
               :webcast_facilitator_id,
               :webcast_id
             ))
  end
end
