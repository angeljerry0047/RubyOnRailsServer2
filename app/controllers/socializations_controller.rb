require 'points'

class SocializationsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_socializable

  def follow
    current_user.follow!(@socializable)
    render json: { follow: true }
  end

  def unfollow
    current_user.unfollow!(@socializable)
    render json: { follow: false }
  end

  def like
    current_user.like!(@socializable)
    if @socializable.gets_a_point and @socializable.got_point == false
      Points.give_them_an_ideator_point(@socializable.user)
      @socializable.update_attributes(:got_point => true)
    end

    if current_user.provider == "salesforce"
      @client = Databasedotcom::Client.new("./config/databasedotcom.yml")
      @client.authenticate :token => current_user.access_key, :instance_url => current_user.instance_url
      @client.version = "23.0"  
      @me = Databasedotcom::Chatter::User.find(@client, "me")
      @me.post_status("I just liked #{@socializable.user.name}'s' idea about #{@socializable.title} on serve2perform. ##{@socializable.category.gsub(/\s+/, "").downcase}")
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @best_practices }
    end
  end

  def validate
    @recommendation = Recommendation.find(socializations_params[:recommendation_id])
    current_user.like!(@socializable)

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @best_practices }
    end
  end

  protected

  def socializations_params
    params.permit(
      :recommendation_id,
      :comment_id,
      :best_practice_id,
      :inquiry_id,
      :item_id,
      :user_id,
      :category_id
    )
  end

  private

  def load_socializable
    @socializable =
      case
      when id = socializations_params[:comment_id] # Must be before :item_id, since it's nested under it.
        @community.comments.find(id)
      when id = socializations_params[:best_practice_id]
        BestPractice.find(id)
      when id = socializations_params[:recommendation_id]
        Recommendation.find(id)
      when id = socializations_params[:inquiry_id]
        Inquiry.find(id)
      when id = socializations_params[:item_id]
        @community.items.find(id)
      when id = socializations_params[:user_id]
        User.find(id)
      when id = socializations_params[:category_id]
        @community.categories.where(id: id).first
      else
        raise ArgumentError, "Unsupported socializable model, params: " +
          socializations_params.keys.inspect
      end
    raise ActiveRecord::RecordNotFound unless @socializable
  end  
end
