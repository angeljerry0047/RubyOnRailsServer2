# == Schema Information
#
# Table name: best_practice_categories
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  public        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  active_tab    :boolean
#  recommendable :boolean
#

class BestPracticeCategory < ActiveRecord::Base
  def self.permitted(params)
    best_practice_whitelist = [:description, :public, :title, :active_tab]
    params.permit(best_practice_category: best_practice_whitelist)
  end

  scope :recommendable, -> { where(:recommendable => true) }
  scope :is_public, -> { where(:public => true).order('created_at desc') }
  scope :is_active, -> { where(:active_tab => true) }

  has_many :organizations_best_practice_categories
  has_many :organizations, :through => :organizations_best_practice_categories
  has_many :best_practices
  has_many :inquries
  has_many :pacs 
  has_many :opportunities
end
