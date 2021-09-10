# == Schema Information
#
# Table name: best_practices
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  title                     :string(255)
#  body                      :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  category                  :string(255)
#  emb_link                  :text
#  ext_link                  :text
#  documents                 :string(255)
#  audio                     :string(255)
#  link_title                :string(255)
#  idea_help                 :text
#  best_practice_category_id :integer
#  organization_id           :integer
#  is_public                 :boolean
#  got_point                 :boolean          default(FALSE)
#  anonymous                 :boolean
#

class BestPractice < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search_full_text, :against => {
    :title => 'A',
    :body => 'B',
  }, :using => [:tsearch]

  def self.permitted(params)
    best_practice_whitelist = [
      :body,
      :title,
      :user_id,
      :category,
      :emb_link,
      :ext_link,
      :documents,
      :documents_cache,
      :audio,
      :audio_cache,
      :best_practice_category_id,
      :link_title,
      :organization_id,
      :idea_help,
      :is_public,
      :got_point,
      :anonymous
    ]

    params.permit(best_practice: best_practice_whitelist)
  end

  mount_uploader :documents, DocumentUploader
  mount_uploader :audio, AudioUploader

  acts_as_likeable

  has_many :comments, :as => :commentable

  belongs_to :user
  belongs_to :organization
  belongs_to :form_of_learning
  belongs_to :best_practice_category

  scope :is_public, -> { where(:is_public => true) }

  scope :with_category, -> category {
    where(:best_practice_category_id => category).
    order('created_at DESC')
  }

  scope :within_organization, -> organization {
    joins(:user).where("users.organization_id" => organization.id)
  }

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
    @like    = Like.where(:likeable_id => self.id).last

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

  # Public:  return the number of users who have 'liked' an Insight
  #
  # Examples
  #
  #  BestPractice.first.likes
  #  #=> 2
  #
  # Returns an Integer representing the number of Users who have 'liked'
  # the given Insight.
  def likes
    likers(User).count
  end

  def external_link
    if (ext_link =~ /http:\/\//) == 0
      ext_link
    else
      "http://" + ext_link
    end
  end

  def external_link_display_text
    if self.link_title.blank?
      "View Link"
    else
      self.link_title
    end
  end

  def gets_a_point
    comments.count > 0 and likers(User).count > 2
  end

  # Public: restrict #find to the is_public scope
  #
  # id - The Integer representing the BestPractice id to be found
  #
  # Examples
  #
  #   Given a private insight:
  #   BestPractice.public_find(42)
  #   #=>  ActiveRecord::RecordNotFound
  #
  #   Given a public insight:
  #   BestPractice.public_find(43)
  #   #=>  #<BestPractice id: 43, ... >
  #
  # Returns a BestPractice object.
  def self.public_find(id)
    BestPractice.is_public.find(id)
  end

  # Public: return the "top ten" public Insights with the most "likes"
  #
  # Examples
  #
  #  BestPractice.popular
  #  #=> [ <#BestPractice ... >, ... ]
  #
  # Returns an Array of the ten public BestPractice objects with the
  # most "likes".
  #
  # NOTE (cmhobbs) public_find here is mostly just a safety net
  def self.top_ten
    BestPractice.top_ten_ids.map { |id| BestPractice.public_find(id) }
  end

  def self.top_ten_for(organization_id)
    BestPractice.top_ten_ids_for(organization_id).map { |id| BestPractice.public_find(id) }
  end

  ################
  # there is no logic in this world...
  #
  # NOTE (cmhobbs) .like_counts, .join_public_likes, and .top_ten_ids
  #      should be cast into their own module or class if they are to
  #      remain.  It might be worth adding a like accumulator column to
  #      the best_practice table to make this more sane.
  ################

  # Public:  Map ordered ids from BestPractice.join_public_likes
  #
  # Examples
  #   BestPractice.like_counts
  #   #=> { "2" => 2, "8" => 1, "12" => 3 }
  #
  # Returns a Hash of public BestPractice ids related to their total
  # likes.
  def self.like_counts
    ids = BestPractice.join_public_likes.map { |row| row.fetch('likeable_id') }
    ids.reduce(Hash.new(0)) { |index, key| index[key] += 1; index }
  end

  # Public:  Get a list of public BestPractice ids (best practices)
  #         without grouping.
  #
  # Examples
  #
  #   BestPractice.join_public_likes
  #   #=> [
  #         { 'likeable_id' => '2'  },
  #         { 'likeable_id' => '2'  },
  #         { 'likeable_id' => '8'  },
  #         { 'likeable_id' => '12' }
  #       ]
  #
  # Returns an enumerable PG::Relation.
  #
  # FIXME (cmhobbs) once ruby 2.0 is on the servers, change this to
  #       the new %{} style strings
  def self.join_public_likes
    query = "SELECT likeable_id FROM likes JOIN best_practices ON likes.likeable_id=best_practices.id WHERE is_public=true AND likeable_type='BestPractice' ORDER BY likeable_id;"
    ActiveRecord::Base.connection.execute(query)
  end

  # Public: Sort BestPractice.like_counts by total likes and select
  # the first ten results.
  #
  # Examples
  #
  #   BestPractice.top_ten_ids
  #   #=> ['12', '8', '2', ... ]
  #
  #   BestPractice.top_ten_ids.count
  #   #=> 10
  #
  # Returns an Array of BestPractice ids as Strings.
  def self.top_ten_ids
    BestPractice.like_counts.sort_by { |_, v| v}.reverse[0..9].map { |tuple| tuple[0] }
  end

  # behaves like .top_ten_ids
  def self.top_ten_ids_for(organization_id)
    Organization.find(organization_id).best_practices.like_counts.sort_by { |_, v| v}.reverse[0..9].map { |tuple| tuple[0] }
  end
end
