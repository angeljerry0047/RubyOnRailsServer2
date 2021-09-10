# frozen_string_literal: true

class BestPracticesController < ApplicationController
  before_filter :authenticate_user!

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by(&:title)
  end

  def index
    if best_practices_params[:organization_id].present?
      unless best_practices_params[:organization_id] == ['']
        @organization = best_practices_params[:organization_id]
      end
    else
      @organization = current_user.unique_groups
    end

    @best_practices = BestPractice.where(organization_id: @organization)

    respond_to do |format|
      format.html
      format.json { render json: @best_practices }
    end
  end

  def show
    @best_practice = BestPractice.find(best_practices_params[:id])
    @commentable   = @best_practice
    @comments      = @commentable.comments
    @comment       = Comment.new
    @organization  = current_user.organization

    respond_to do |format|
      format.html
      format.json { render json: @best_practice }
    end
  end

  def new
    if best_practices_params[:organization_id].present?
      unless best_practices_params[:organization_id] == ['']
        @organization_id = best_practices_params[:organization_id]
      end
    else
      @organization_id = nil
    end

    @best_practice = BestPractice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @best_practice }
    end
  end

  def edit
    @best_practice = BestPractice.find(best_practices_params[:id])
  end

  # FIXME: (cmhobbs+tyreldenison) refactor this.  severl methods could be extracted
  def create
    best_practices_params[:best_practice][:organization_id].each do |organization_id|
      @best_practice                 = BestPractice.new
      @best_practice.organization_id = organization_id
      @best_practice.title           = params[:best_practice][:title]
      @best_practice.body            = params[:best_practice][:body]
      @best_practice.anonymous       = params[:best_practice][:anonymous]
      @best_practice.emb_link        = params[:best_practice][:emb_link]
      @best_practice.ext_link        = params[:best_practice][:ext_link]
      @best_practice.documents       = params[:best_practice][:documents]
      @best_practice.documents_cache = params[:best_practice][:documents_cache]
      @best_practice.audio_cache     = params[:best_practice][:audio_cache]

      if !params[:best_practice][:ext_link].empty? && params[:best_practice][:link_title].empty?
        @best_practice.link_title = params[:best_practice][:ext_link]
      else
        @best_practice.link_title = params[:best_practice][:link_title]
      end

      @best_practice.user_id         = current_user.id
      @category                      = @best_practice.category

      # XXX (cmhobbs) GOTCHA, @best_practice will repeatedly get clobbered
      if @best_practice.save
        if current_user.provider == 'salesforce'
          @client = Databasedotcom::Client.new('./config/databasedotcom.yml')
          @client.authenticate token: current_user.access_key, instance_url: current_user.instance_url
          @client.version = '23.0'
          @me = Databasedotcom::Chatter::User.find(@client, 'me')
          @me.post_status("I just added an idea about #{@best_practice.title} on serve2perform. ##{@best_practice.category.gsub(/\s+/, '').downcase}")
        # FIXME: (cmhobbs) extract this into some kind of notifier
        elsif @best_practice.organization_id?
          if @best_practice.organization.members.empty?
            BestPracticeEmailWorker.perform_async(@best_practice.id, @best_practice.organization.users.pluck(:id))
          else
            @best_practice.organization.members.each do |member|
              next if member.mute_notifications

              # NOTE (cmhobbs) rails 4.2 change:
              Notifier.delay.new_best_practice_email(member, @best_practice)
              # Notifier.new_best_practice_email(member, @best_practice).deliver_later
            end

            # NOTE (conradwt) Is the following line required?
            # BestPracticeEmailWorker.perform_async(@best_practice.id, @best_practice.organization.members.pluck(:id))
          end
        else
          BestPracticeEmailWorker.perform_async(@best_practice.id, @best_practice.user.organization.users.pluck(:id))
        end
      end

      if @best_practice.save && @best_practice.is_public
        EmailWorker.perform_async(@best_practice.id)
      end
    end

    # NOTE (cmhobbs) will redirect to the last created best practice
    respond_to do |format|
      format.html { redirect_to @best_practice, notice: 'Your Insight was successfully created.' }
      format.json { render json: @best_practice, status: :created, location: @best_practice }
    end
  end

  def update
    @best_practice = BestPractice.find(best_practices_params[:id])

    respond_to do |format|
      if @best_practice.update_attributes(best_practices_params[:best_practice])
        format.html { redirect_to @best_practice, notice: 'Insight was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @best_practice.errors, status: :unprocessable_entity }
      end
    end
  end

  def documents
    Rails.logger.warn('Tombstone 8-3-2015 MK: Deprecate this method BestPractices#documents')
    best_practice = BestPractice.find(best_practices_params[:id])
    send_file best_practice.documents.path
  end

  def audio
    Rails.logger.warn('Tombstone 8-3-2015 MK: Deprecate this method BestPractices#audio')
    best_practice = BestPractice.find(best_practices_params[:id])
    send_file best_practice.audio.path
  end

  def destroy
    @best_practice = BestPractice.find_by(id: params[:id])

    if @best_practice&.destroy
      redirect_to best_practices_path
      # respond_to do |format|
      #   redirect_to best_practices_path
      #   #format.html { redirect_to organization_path(current_user.organization), notice: "Insight was sucessfully deleted." }
      #   format.json { head :no_content }
      # end
    end
  end

  def duplicate
    @organization      = current_user.organization
    @best_practice_dup = BestPractice.find(best_practices_params[:id])
    @new_best_practice = @best_practice_dup.dup

    @new_best_practice.category = BestPracticeCategory.find(best_practices_params[:organization][:best_practice_category_id]).title
    @new_best_practice.best_practice_category_id = best_practices_params[:organization][:best_practice_category_id]
    @new_best_practice.is_public = false
    @new_best_practice.documents = @best_practice_dup.documents
    @new_best_practice.documents_cache = @best_practice_dup.documents_cache
    @new_best_practice.audio = @best_practice_dup.audio
    @new_best_practice.audio_cache = @best_practice_dup.audio_cache
    @new_best_practice.comments = @best_practice_dup.comments.map(&:dup)

    @best_practice_dup.likers(User).each do |liker|
      liker.like!(@new_best_practice)
    end

    respond_to do |format|
      if @new_best_practice.save!
        format.html { redirect_to @new_best_practice, notice: "Insight was successfully added to your internal page under category #{@new_best_practice.category}." }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @best_practice.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def best_practices_params
    # XXX (cmhobbs) considered harmful but so are stupid rails tricks
    #
    # https://stackoverflow.com/questions/15919761/nested-attributes-unpermitted-parameters/17267343#17267343
    params.permit!
    # BestPractice
    #   .permitted(params)
    #   .merge(Organization.permitted(params))
    #   .merge(params.permit(:best_practice_category_id, :organization_id, :id))
  end
end
