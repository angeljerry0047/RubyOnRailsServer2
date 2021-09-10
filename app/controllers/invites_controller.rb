class InvitesController < ApplicationController

  before_filter :authenticate_user!

  def create
    connection = invite_params[:connection]

    @invite = Invite.new(
      :oid        => connection[:id], 
      :first_name => connection[:first_name], 
      :last_name  => connection[:last_name],
      :user_id    => current_user.id,
      :provider   => 'linkedin'
     )

    if @invite.save
      render :json => {:status => "success", :message => "You invited #{connection[:first_name]} to Serve2Perform!"}
    else
      render :json => {:status => "error", :message => "There was an error inviting your colleague."}
    end
  end

  def index
    @page = (invite_params[:page].to_i == 0) ? 1 : invite_params[:page].to_i
    @increment = 16

    if(invite_params[:q])
      fields = [{:people => [:id, :first_name, :last_name, :picture_url]}, :num_results]
      results = current_user.to_linkedin_client.client.search(:keywords => invite_params[:q], :facet => ["network,F"], :fields => fields, :start => (@page-1) * @increment, :count => 16)
      @connections = results.people.all
      @total = results.total_results
    elsif
      results = current_user.connections(:start => (@page-1) * @increment)
      @connections = results.all
      @total = results.total
    else
      redirect_to "/users/sign_in", :message => "Please Click Sign In with LinkedIn to reestablish your connection."
    end

    @last_page = (@total/ @increment.to_f).ceil
  end

  def invite_email
    @invite_email = Invite.new
  end

  def send_email
    @current_user = current_user

    if Notifier.new_invite_email_collegue_email(invite_params[:emails], current_user).deliver
      redirect_to invite_email_invites_path, :notice => 'Your invite(s) have been sent!'
    else
      redirect_to invite_email_invites_path, :notice => "Your invite(s) could not be sent. Please retry."
    end
  end

  protected

  def invite_params
    Invite
      .permitted(params)
      .merge(params.permit(connection: [:id, :first_name, :last_name]))
      .merge(params.permit(:page, :q, :id, :first_name, :emails, :last_name))
  end


end
