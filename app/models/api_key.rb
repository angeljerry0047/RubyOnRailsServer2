# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string(255)
#  expires_at   :datetime
#  active       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  role         :integer
#

class ApiKey < ActiveRecord::Base

  # TODO (cmhobbs) re-enable this when we hit rails 4+
  #enum role: [:superuser, :readwrite, :read]

  before_create   :generate_access_token

  # NOTE (cmhobbs) Roles should be considered to be tiered
  # (e.g. superuser is also readwrite and read).  This should provide
  # a handy reference for other access levels.
  #def access_levels
  #  ApiKey.roles.select { |_, v| v >= ApiKey.roles[role] }
  #end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end
