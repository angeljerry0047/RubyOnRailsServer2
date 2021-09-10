class OrganizationReport < ActiveRecord::Base  

  ######
  # FIXME (cmhobbs) remove this and rely on the schema

  def self.columns() @columns ||= []; end  

  def self.column(name, sql_type = nil, default = nil, null = true)  
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)  
  end  

  column :organization_id, :integer
  column :organization_title, :string
  column :created_at, :timestamps
  column :users_nbr, :integer
  column :pdes_created_nbr, :integer
  column :pdes_attended_nbr, :integer
  column :max_width, :integer
  column :users_width, :integer
  column :created_width, :integer
  column :attended_width, :integer
  
  ######

  def calc_report(organization_id)

    @organization = Organization.find(organization_id)

    self.organization_id = @organization.id
    self.organization_title = @organization.title
    self.created_at = Time.now
    self.users_nbr = User.where(:organization_id => organization_id).count
    self.pdes_created_nbr = Opportunity.where(:organization_id => organization_id).count
    self.pdes_attended_nbr = OpportunityApplication.joins(:user).where("users.organization_id = ? ", organization_id).count

    self.max_width = 482
    @max_score = 40    

    self.users_width = ((self.users_nbr/@max_score.to_f)*self.max_width).ceil
    self.created_width = ((self.pdes_created_nbr/@max_score.to_f)*self.max_width).ceil
    self.attended_width = ((self.pdes_attended_nbr/@max_score.to_f)*self.max_width).ceil  

  end

  # XXX (cmhobbs) ActiveRecord gives us this functionality
  def find(id)  

    @organization = Organization.find(id)

    self.organization_id = @organization.id
    self.organization_title = @organization.title
    self.created_at = Time.now
    self.users_nbr = User.where(:organization_id => id).count
    self.pdes_created_nbr = Opportunity.where(:organization_id => id).count
    self.pdes_attended_nbr = OpportunityApplication.joins(:user).where("users.organization_id = ? ", id).count

    self.max_width = 482
    @max_score = 40    

    self.users_width = ((self.users_nbr/@max_score.to_f)*self.max_width).ceil
    self.created_width = ((self.pdes_created_nbr/@max_score.to_f)*self.max_width).ceil
    self.attended_width = ((self.pdes_attended_nbr/@max_score.to_f)*self.max_width).ceil      

  end  


end  
