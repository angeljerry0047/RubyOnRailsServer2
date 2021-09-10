# FIXME (cmhobbs+tyreldenison) kill it with sweet cleansing fire.
module AutomakeFacility
  def self.included(base)
    base.before_save :automake_facility

    # FIXME (cmhobbs+tyreldenison) this is a security/access control issue
    base.send(:attr_accessor,   :facility_name)
    base.send(:attr_accessor,   :facility_map_location)
    base.send(:attr_accessor,   :facility_address)
    base.send(:attr_accessor,   :facility_approval_name)
    base.send(:attr_accessor,   :facility_approval_mail)
  end

  def self.permitted_whitelist
    [
      :facility_name,
      :facility_map_location,
      :facility_address,
      :facility_approval_name,
      :facility_approval_mail
    ]
  end
  
  def automake_facility
    if facility_id == 0
      unless Facility.exists?(:name => facility_name, :city => city, :state => state)
        fac = Facility.create!(
          :name          => facility_name, 
          :city          => city,
          :state         => state,
          :address       => facility_address,
          :map_location  => facility_map_location,
          :approval_name => facility_approval_name,
          :approval_mail => facility_approval_mail)
        self.facility_id = fac.id
      else
        @facility = Facility.where(:name => facility_name, :city => city, :state => state).first
        self.facility_id = @facility.id
      end
    end
  end
end
