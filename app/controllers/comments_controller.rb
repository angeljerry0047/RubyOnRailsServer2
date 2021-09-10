require 'points'
include Points 

class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params[:comment])
    @comment.user_id = current_user.id

    # FIXME (cmhobbs) refactor.
    if @comment.save
      if @commentable.gets_a_point && @commentable.got_point == false
        Points.give_them_an_ideator_point(@commentable.user)
        @commentable.update_attributes(:got_point => true)
      end
      if current_user.provider == "salesforce" && @commentable.is_a?(BestPractice)
        @client = Databasedotcom::Client.new("./config/databasedotcom.yml")
        @client.authenticate :token => current_user.access_key, :instance_url => current_user.instance_url
        @client.version = "23.0"  
        @me = Databasedotcom::Chatter::User.find(@client, "me")
        @me.post_status("I just commented on #{@commentable.user.name}'s' idea about #{@commentable.title} on serve2perform. ##{@commentable.category.gsub(/\s+/, "").downcase}")
      elsif @commentable.is_a?(BestPractice)
        CommentWorker.perform_async(@comment.id)
      elsif @commentable.is_a?(Inquiry)
        AnswerWorker.perform_async(@comment.id)
      elsif @commentable.class.name == "Pac"
        @commentable.pac_members.each do |member|
          Notifier.new_pac_comment_email(member, @commentable, @comment).deliver_now!
        end
      end
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end

  protected

  def comment_params
    Comment.permitted(params)
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
