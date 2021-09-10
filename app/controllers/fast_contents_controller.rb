class FastContentsController < ApplicationController
  before_filter :authenticate_user!

  expose(:all_groups_sorted) do
    current_user.unique_groups.sort_by { |organization| organization.title }
  end

  def index
    if fast_content_params[:organization_id].present?
      @organization = fast_content_params[:organization_id] unless fast_content_params[:organization_id] == ['']
    else
      @organization = current_user.unique_groups
    end

    @fast_contents = FastContent.where(organization_id: @organization)

    respond_to do |format|
      format.html
      format.json { render json: @fast_contents }
    end
  end

  def show
    @fast_content = FastContent.find(fast_content_params[:id])
    @organization = Organization.find_by(id: @fast_content.organization_id)

    @organization_title = if @organization
                            @organization.title
                          else
                            ''
                          end

    respond_to do |format|
      format.html
      format.json { render json: @fast_content }
    end
  end

  def new
    if fast_content_params[:organization_id].present?
      @organization_id = fast_content_params[:organization_id] unless fast_content_params[:organization_id] == ['']
    else
      @organization_id = nil
    end

    @fast_content = FastContent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fast_content }
    end
  end

  def edit
    @fast_content = FastContent.find(fast_content_params[:id])
  end

  def create
    @fast_content = FastContent.new(fast_content_params[:fast_content])
    @fast_content.user_id = current_user.id
    unless fast_content_params[:fast_content][:organization_id].present?
      @fast_content.organization_id = current_user.organization_id
    end

    respond_to do |format|
      if @fast_content.save
        format.html { redirect_to @fast_content, notice: 'Fast content was successfully created.' }
        format.json { render json: @fast_content, status: :created, location: @fast_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @fast_content.errors, status: :unprocessable_entity }
      end
    end
  end

  def documents
    Rails.logger.warn('Tombstone 8-3-2015 MK: This should be deprecated FastContent#documents')
    fast_content = FastContent.find(fast_content_params[:id])
    send_file fast_content.documents.path
  end

  def audio
    Rails.logger.warn('Tombstone 8-3-2015 MK: This should be deprecated FastContent#audio')
    fast_content = FastContent.find(fast_content_params[:id])
    send_file fast_content.audio.path
  end

  def update
    @fast_content = FastContent.find(fast_content_params[:id])

    respond_to do |format|
      if @fast_content.update_attributes(fast_content_params[:fast_content])
        format.html { redirect_to @fast_content, notice: 'Fast content was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fast_content.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @fast_content = FastContent.find(fast_content_params[:id])
    @fast_content.destroy

    respond_to do |format|
      format.html do
        redirect_to organization_path(current_user.organization.slug), notice: 'Fast content was sucessfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  protected

  def fast_content_params
    FastContent.permitted(params).merge(params.permit(:organization_id, :id))
  end
end
