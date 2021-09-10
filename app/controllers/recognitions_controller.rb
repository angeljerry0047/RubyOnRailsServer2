# frozen_string_literal: true

class RecognitionsController < ApplicationController
  before_filter :authenticate_user!, except: %i[about speaker_series]

  expose(:badge_types) { BadgeType.awardable }

  # NOTE (cmhobbs) convience exposure for the new recognition view
  expose(:user_id) { recognitions_params[:user_id] }

  # XXX (cmhobbs) this code and its view were copied from RecommendationsController
  #     under duress.
  def find
    @search = recognitions_params[:searchUser]
    if !@search.nil?
      if @search != ''
        # XXX (cmhobbs) none of this db nonsense in the controllers, please
        @users = User.joins('LEFT JOIN organizations ON organizations.id=users.organization_id')
                     .where('users.name ILIKE ? OR organizations.title ILIKE ?', "%#{@search}%", "%#{@search}%")
      else
        @users = nil
      end
    else
      @users = nil
    end
  end

  def create
    user = User.find(recognitions_params[:recognition][:user_id])

    # NOTE (cmhobbs) gross flow control based on params.  this would be better handled with
    #      javascript directly on the page.  adding this as a stop-gap before the new design
    if params[:recognition][:badge_type_id].blank?
      redirect_to(new_recognition_path(user_id: user.id), flash: { notice: 'Please select a badge' }) && return
    end

    if user.award_badge(params[:recognition][:badge_type_id])
      redirect_to user_path(user.id)
    else
      redirect_to new_recognition_path(user_id: user.id), flash: { error: 'User has already been awarded this badge' }
    end
  end

  protected

  def recognitions_params
    User
      .permitted(params)
      .merge(params.permit(recognition: %i[user_id badge_type_id]))
      .merge(params.permit(:searchUser, :user_id))
  end
end
