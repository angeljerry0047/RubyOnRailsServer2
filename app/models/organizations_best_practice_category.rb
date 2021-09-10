# == Schema Information
#
# Table name: organizations_best_practice_categories
#
#  best_practice_category_id :integer
#  organization_id           :integer
#

class OrganizationsBestPracticeCategory < ActiveRecord::Base
  belongs_to :organization
  belongs_to :best_practice_category
end
