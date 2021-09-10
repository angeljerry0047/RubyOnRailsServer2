class RecommendationsController < ApplicationController

  before_filter :authenticate_user!

  def find   
    @search = recommendation_params[:searchUser]
    if @search!=nil
      if @search != ''
        # XXX (cmhobbs) none of this db nonsense in the controllers, please
        @users  = User.joins('LEFT JOIN organizations ON organizations.id=users.organization_id')
        .where('users.name ILIKE ? OR organizations.title ILIKE ?' ,  "%#{@search}%",  "%#{@search}%")
      else
        @users  = nil
      end
    else
      @users  = nil
    end
  end  

  def index
    @recommendations = Recommendation.all

    respond_to do |format|
      format.html
      format.json { render json: @recommendations }
    end
  end

  def list
    @recommendations = Recommendation.all

    respond_to do |format|
      format.html
      format.json { render json: @recommendations }
    end
  end

  def show
    @recommendation = Recommendation.find(recommendation_params[:id])
    @commentable    = @recommendation
    @comments       = @commentable.comments
    @comment        = Comment.new

    respond_to do |format|
      format.html
      format.json { render json: @recommendation }
    end
  end

  def new
    @recommendation = Recommendation.new

    @user = User.find(recommendation_params[:user_id])

    respond_to do |format|
      format.html
      format.json { render json: @recommendation }
    end
  end

  def edit
    @recommendation = Recommendation.find(recommendation_params[:id])
  end

  def approve
    @recommendation = Recommendation.find(recommendation_params[:id])

    if recommendation_params[:event] == 'accepted'
      @recommendation.update_attributes(approval_status: true)
      if recommendation_params[:internal] == "true"
        @recommendation.update_attributes(internal: true)
        Notifier.new_recommendation_approval(@recommendation).deliver_now!
      end
      if current_user.provider == "salesforce"
        @client = Databasedotcom::Client.new("./config/databasedotcom.yml")
        @client.authenticate :token => current_user.access_key, :instance_url => current_user.instance_url
        @client.version = "23.0"
        @me = Databasedotcom::Chatter::User.find(@client, "me")
        @me.post_status("I was recommended as a #{@recommendation.opportunity_category.name} on serve2perform.")
      end
      redirect_to recommendation_path(@recommendation.id), :notice => "Successfully Approved Recommendation"
    end
  end

  def create
    @recommendation = Recommendation.new(recommendation_params[:recommendation])
    @recommendation.creator_id = current_user.id
    @recommendation.update_attributes({:end_year => DateTime.now.year, :end_month => DateTime.now.month-1})
    @user = @recommendation.user_id

    if @recommendation.save
      Notifier.new_recommendation_email(@recommendation).deliver_now!
    end

    respond_to do |format|
      if @recommendation.save
        format.html { redirect_to user_path(@user), notice: 'Recommendation was successfully created.' }
        format.json { render json: @recommendation, status: :created, location: @recommendation }
      else
        format.html { render action: "new" }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end


  # FIXME (cmhobbs) refactor
  def update
    @recommendation = Recommendation.find(recommendation_params[:id])
    if recommendation_params.fetch(:expire, "false") == "true"
      if @recommendation.update_attributes!({:end_year => DateTime.now.year, :end_month => DateTime.now.month-1})
        redirect_to edit_many_skills_path, :notice => "Successfully expired skill"
      else
        redirect_to edit_many_skills_path, :flash => {:error => "There was an error expiring your skill"}
      end
    elsif recommendation_params.fetch(:reactivate, "false") == "true"
      if @recommendation.update_attributes!({:end_year => DateTime.now.year+3, :end_month => DateTime.now.month})
        if current_user.provider == "salesforce"
          @client = Databasedotcom::Client.new("./config/databasedotcom.yml")
          @client.authenticate :token => current_user.access_key, :instance_url => current_user.instance_url
          @client.version = "23.0"  
          @me = Databasedotcom::Chatter::User.find(@client, "me")
          @me.post_status("I was recommended as a #{@recommendation.opportunity_category.name} on serve2perform.")
        end
        redirect_to edit_many_skills_path, :notice => "Successfully activated skill"
      else
        redirect_to edit_many_skills_path, :flash => {:error => "There was an error activating your skill"}
      end
    else
      respond_to do |format|
        if @recommendation.update_attributes(recommendation_params[:recommendation])
          if recommendation_params[:recommendation][:approval_status] == "true"
            @recommendation.update_attributes!({:end_year => DateTime.now.year+3, :end_month => DateTime.now.month})
            Notifier.new_recommendation_approval(@recommendation).deliver_now!
          end
          if current_user.provider == "salesforce"
            @client = Databasedotcom::Client.new("./config/databasedotcom.yml")
            @client.authenticate :token => current_user.access_key, :instance_url => current_user.instance_url
            @client.version = "23.0"  
            @me = Databasedotcom::Chatter::User.find(@client, "me")
            @me.post_status("I was recommended as a #{@recommendation.opportunity_category.name} on serve2perform.")
          end
          format.html { redirect_to @recommendation, notice: 'Recommendation was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @recommendation.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def register_pde
    @recommendation = Recommendation.find(recommendation_params[:id])
  end


  def destroy
    @recommendation = Recommendation.find(recommendation_params[:id])
    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_to recommendations_url }
      format.json { head :no_content }
    end
  end

  protected

  def recommendation_params
    Recommendation
      .permitted(params)
      .merge(User.permitted(params))
      .merge(params.permit(:id, :event, :internal, :searchUser, :expire, :reactivate, :user_id))
  end


end
