# == Schema Information
#
# Table name: organizations
#
#  id               :integer          not null, primary key
#  type             :string(255)
#  title            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  description      :text
#  company_size_min :integer
#  company_size_max :integer
#  company_type     :string(255)
#  website          :string(255)
#  industry_id      :integer
#  operating_status :string(255)
#  year_founded     :integer
#  address1         :string(255)
#  address2         :string(255)
#  city             :string(255)
#  state            :string(255)
#  zipcode          :integer
#  oid              :string(255)
#  provider         :string(255)
#  avatar           :string(255)
#  banner           :string(255)
#  active_license   :boolean
#  salesforce_id    :string(255)
#  has_chatter      :boolean
#  user_licenses    :integer
#  int_description  :text
#  domain           :string(255)
#  meta_group_id    :integer
#

class NonProfit < Organization; end
