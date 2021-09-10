# FIXME (cmhobbs+tyreldenison) move this to lib
module AutomakeOrganization
  def self.included(base)
    base.before_save :automake_organization

    # FIXME (cmhobbs+tyreldenison) this is a security/access control issue
    base.send(:attr_accessor, :organization_name)
  end

  def self.permitted_whitelist
    [:organization_name]
  end
  
  def automake_organization
    if organization_id.blank? && organization_name.present? && !Organization.exists?(:title => organization_name)
      org = Organization.create!(:title => organization_name)
      self.organization_id = org.id
    end
  end
end
