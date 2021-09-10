class InquiriesController < ApplicationController

  before_filter :authenticate_user!

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by { |organization| organization.title }
  end

  def index
    if inquiries_params[:organization_id].present?
     unless inquiries_params[:organization_id] == [""]
      @organization =  inquiries_params[:organization_id]
     end
    else
      @organization = current_user.unique_groups
    end

    @inquiries = Inquiry.where(organization_id: @organization)

    respond_to do |format|
      format.html
      format.json { render json: @inquiries }
    end
  end

  def show
    @inquiry      = Inquiry.find(inquiries_params[:id])
    @commentable  = @inquiry
    @comments     = @commentable.comments
    @comment      = Comment.new
    @organization = current_user.organization

    respond_to do |format|
      format.html
      format.json { render json: @inquiry }
    end
  end

  def new
    if inquiries_params[:organization_id].present?
     unless inquiries_params[:organization_id] == [""]
      @organization_id =  inquiries_params[:organization_id]
     end
    else
      @organization_id = nil
    end

    #@organization_id = current_user.organization_id
    
    @inquiry = Inquiry.new

    respond_to do |format|
      format.html
      format.json { render json: @inquiry }
    end
  end

  def edit
    @inquiry = Inquiry.find(inquiries_params[:id])
  end

  def create
    @inquiry         = Inquiry.new(inquiries_params[:inquiry])
    @inquiry.user_id = current_user.id
    @category        = @inquiry.category

    if @category.nil?
      @inquiry.category = BestPracticeCategory.find(@inquiry.best_practice_category_id).title
    end

    respond_to do |format|
      if @inquiry.save
        if current_user.provider == "salesforce"
          @client = Databasedotcom::Client.new("./config/databasedotcom.yml")
          @client.authenticate :token => current_user.access_key, :instance_url => current_user.instance_url
          @client.version = "23.0"  
          @me = Databasedotcom::Chatter::User.find(@client, "me")
          @me.post_status("I just asked a question about #{@inquiry.title} on serve2perform. ##{@inquiry.category.gsub(/\s+/, "").downcase}")
        elsif @inquiry.organization_id?
          if @inquiry.organization.members.empty?
            @inquiry.organization.users.each do |member|
              unless member.mute_notifications
                Notifier.delay.new_inquiry_email(member, @inquiry)
              end
            end                        
          else
            @inquiry.organization.members.each do |member|
              unless member.mute_notifications
                Notifier.delay.new_inquiry_email(member, @inquiry)
              end
            end
          end
        else
          @inquiry.user.organization.users.each do |member|
            unless member.mute_notifications
              Notifier.delay.new_inquiry_email(member, @inquiry)
            end
          end
        end
        format.html { redirect_to @inquiry, notice: 'Question was successfully created.' }
        format.json { render json: @inquiry, status: :created, location: @inquiry }
      else
        format.html { render action: "new" }
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end

    # FIXME (cmhobbs+tyreldenison) @inquiry is saved twice
    if @inquiry.save && @inquiry.is_public
      QuestionWorker.perform_async(@inquiry.id)
    end
  end

  def update
    @inquiry = Inquiry.find(inquiries_params[:id])

    respond_to do |format|
      if @inquiry.update_attributes(inquiries_params[:inquiry])
        format.html { redirect_to @inquiry, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  def documents
    Rails.logger.warn("Tombstone 8-3-2015 MK: This action InquiriesController#documents should be deprecated")
    inquiry = Inquiry.find(inquiries_params[:id])
    send_file inquiry.documents.path
  end

  def destroy
    @inquiry = Inquiry.find(inquiries_params[:id])
    @inquiry.destroy

    respond_to do |format|
      format.html { redirect_to organization_path(current_user.organization.slug), notice: "Question was sucessfully deleted." }
      format.json { head :no_content }
    end
  end

  def duplicate
    @organization = current_user.organization
    @inquiry_dup  = Inquiry.find(inquiries_params[:id])
    @new_inquiry  = @inquiry_dup.dup

    @new_inquiry.category = BestPracticeCategory.find(inquiries_params[:organization][:best_practice_category_id]).title
    @new_inquiry.best_practice_category_id = inquiries_params[:organization][:best_practice_category_id]
    @new_inquiry.is_public = false
    @new_inquiry.documents = @inquiry_dup.documents
    @new_inquiry.documents_cache = @inquiry_dup.documents_cache
    @new_inquiry.comments = @inquiry_dup.comments.map{|bpc| bpc.dup}
    @inquiry_dup.likers(User).each do |liker|
      liker.like!(@new_inquiry)
    end

    respond_to do |format|
      if @new_inquiry.save!
        format.html { redirect_to @new_inquiry, notice: "Question was successfully added to your internal page under category #{@new_inquiry.category}." }
        format.json { head :no_content }
      else
        format.html { render action: "show" }
        format.json { render json: @inquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def inquiries_params
    Inquiry
      .permitted(params)
      .merge(Organization.permitted(params))
      .merge(params.permit(:id, :organization_id))
  end

end
