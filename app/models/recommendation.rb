# == Schema Information
#
# Table name: recommendations
#
#  id                      :integer          not null, primary key
#  creator_id              :integer
#  user_id                 :integer
#  approval_status         :boolean
#  opportunity_category_id :integer
#  con_strength            :string(255)
#  con_engagement          :string(255)
#  con_length              :string(255)
#  con_type                :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  internal                :boolean
#  end_year                :integer
#  end_month               :integer
#  con_performance         :string(255)
#  rec_type                :string(255)
#  con_text                :text
#

class Recommendation < ActiveRecord::Base
  def self.permitted(params)
    recommendation_whitelist = [
      :approval_status,
      :con_engagement,
      :con_length,
      :con_strength,
      :con_performance,
      :con_type,
      :creator_id,
      :id,
      :opportunity_category_id,
      :user_id,
      :internal,
      :end_year,
      :end_month,
      :rec_type,
      :con_text
    ]

    params.permit(recommendation: recommendation_whitelist)
  end

  acts_as_likeable

  belongs_to :opportunity_category
  belongs_to :user
  belongs_to :creator, :class_name => "User"
  belongs_to :form_of_learning

  has_many :recommendation_applications
  has_many :applicants, :through => :recommendation_applications, :source => :user
  has_many :comments, :as => :commentable

  scope :approved, -> { where(:approval_status => true) }

  # FIXME (cmhobbs+tyreldenison) fix opportunity category and this will be fixed
  scope :mentor,    -> { where(:opportunity_category_id => [4, 15, 17]) }
  scope :coach,     -> { where(:opportunity_category_id => [8, 14, 10, 16, 1, 18]) }
  scope :advisor,   -> { where(:opportunity_category_id => [4, 15, 17, 8, 14, 10, 16, 1, 18]) }
  scope :intern,    -> { where(:opportunity_category_id => [6, 19]) }
  scope :speaker,   -> { where(:opportunity_category_id => [2, 9, 7, 20]) }
  scope :volunteer, -> { where(:opportunity_category_id => [5, 21]) }

  scope :active, -> {
    where(:approval_status => true ).
    where('end_year IS NULL OR (end_year > :year) OR (end_year = :year AND end_month >= :month)', :year => Time.now.year, :month => Time.now.month)
  }

  scope :with_category, -> category {
    where(:opportunity_category_id => category.id)
  }

  scope :within_organization, -> organization {
    joins(:user).where("users.organization_id" => organization.id)
  }

  scope :external, -> { where(:internal => false) }

  # FIXME (cmhobbs+tyreldenison) we know the drill by now.  deduplicate
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

  def trending_points
    @comment = Comment.where(:commentable_id => self.id).last
    @like = Like.where(:likeable_id => self.id).last
    if @comment == nil && @like == nil
      @trend = self.freshness
    elsif @like == nil
      @trend = self.freshness + @comment.freshness
    elsif @comment == nil
      @trend = self.freshness + @like.freshness
    else 
      @trend = self.freshness + @like.freshness + @comment.freshness
    end    
  end

  # FIXME (cmhobbs+mbindya) rename this to likes
  def popular
    self.likers(User).count
  end

end
