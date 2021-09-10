# == Schema Information
#
# Table name: inquiries
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  body                      :text
#  user_id                   :integer
#  organization_id           :integer
#  category                  :string(255)
#  best_practice_category_id :integer
#  documents                 :string(255)
#  is_public                 :boolean          default(FALSE)
#  got_point                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Inquiry < ActiveRecord::Base
  include PgSearch::Model
  pg_search_scope :search_full_text, against: {
    title: 'A',
    body: 'B'
  }, using: [:tsearch]

  def self.permitted(params)
    inquiry_whitelist = %i[
      best_practice_category_id
      body
      category
      documents
      documents_cache
      got_point
      is_public
      organization_id
      title
      user_id
    ]

    params.permit(inquiry: inquiry_whitelist)
  end

  mount_uploader :documents, DocumentUploader

  acts_as_likeable

  has_many :comments, as: :commentable

  belongs_to :user
  belongs_to :organization
  belongs_to :form_of_learning
  belongs_to :best_practice_category

  scope :is_public, -> { where(is_public: true) }

  scope :with_category, lambda { |category|
    where(best_practice_category_id: category)
      .order('created_at DESC')
  }

  scope :within_organization, lambda { |organization|
    joins(:user).where('users.organization_id' => organization.id)
  }

  # FIXME: (cmhobbs+tyreldension) remove this duplicate method
  def freshness
    @date   = created_at.to_date
    @date40 = (Date.today - 40.days..Date.today - 31.days)
    @date30 = (Date.today - 30.days..Date.today - 21.days)
    @date20 = (Date.today - 20.days..Date.today - 11.days)
    @date10 = (Date.today - 10.days..Date.today - 6.days)
    @date5  = (Date.today - 5.days..Date.today - 1.day)

    if @date40.cover?(@date)
      1
    elsif @date30.cover?(@date)
      2
    elsif @date20.cover?(@date)
      3
    elsif @date10.cover?(@date)
      4
    elsif @date5.cover?(@date)
      5
    elsif @date == Date.today
      10
    else
      0
    end
  end

  def trending_points
    @comment = Comment.where(commentable_id: id).last
    @like = Like.where(likeable_id: id).last
    @trend = if @comment.nil? && @like.nil?
               freshness
             elsif @like.nil?
               freshness + @comment.freshness
             elsif @comment.nil?
               freshness + @like.freshness
             else
               freshness + @like.freshness + @comment.freshness
             end
  end

  # FIXME: (cmhobbs+mbindya) rename this to likes
  def popular
    likers(User).count
  end

  def external_link
    if (ext_link =~ %r{http://}) == 0
      ext_link
    else
      'http://' + ext_link
    end
  end

  def gets_a_point
    comments.count > 0 and likers(User).count > 2
  end
end
