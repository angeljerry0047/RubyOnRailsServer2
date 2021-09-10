# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#

class Comment < ActiveRecord::Base
  def self.permitted(params)
    comment_whitelist = [
      :content,
      :commentable_id,
      :commentable_type,
      :user_id
    ]

    params.permit(comment: comment_whitelist)
  end

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  # FIXME (cmhobbs+tyreldension) this method is duplicated all over the models
  def freshness
    @date   = self.created_at.to_date
    @date40 = (Date.today - 40.days..Date.today - 31.days)
    @date30 = (Date.today - 30.days..Date.today - 21.days)
    @date20 = (Date.today - 20.days..Date.today - 11.days)
    @date10 = (Date.today - 10.days..Date.today - 6.days)
    @date5  = (Date.today - 5.days..Date.today - 1.day)

    case 
      when @date40.cover?(@date)
        1
      when @date30.cover?(@date)
        2
      when @date20.cover?(@date)
        3
      when @date10.cover?(@date)
        4
      when @date5.cover?(@date)
        5
      when @date == Date.today
        10    
      else 
        0  
    end
  end
  
end
