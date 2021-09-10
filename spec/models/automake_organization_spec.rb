require 'spec_helper'

describe AutomakeOrganization do 
  [:user, :opportunity].each do |klass|
    context "Automake organization for #{klass}" do
      # 4 Cases:
      # org_name set, org_id set: Rely on org_id
      # org_name set, org_id not set: Create new organization named org_name
      # org_name not set, org_id set: Rely on org_id superfluous
      # org_name not set, org_id not_set: Do nothing

      it 'relies on organization_id when given both organization_name and organization_id' do
        org = FactoryBot.create(:company)
        org_name = "Foobaz Corp."
        
        instance = FactoryBot.build(klass)
        instance.organization_id = org.id
        instance.organization_name = org_name
        
        instance.save!
        Organization.exists?(:title => org_name).should_not be_truthy
        instance.reload.organization_id.should == org.id
      end
      
      it 'creates a new organization when theres no org_id but an org_name set' do
        org_name = 'Foobaz Corp.'
        instance = FactoryBot.build(klass)
        instance.organization_name = org_name
        instance.organization_id = nil
        instance.save!
        
        Organization.exists?(:title => org_name).should be_truthy
        instance.reload.organization.title.should == org_name
      end
      
      it 'does nothing when given nothing' do
        Organization.count.should == 0
        instance = FactoryBot.build(klass)
        instance.organization_name = nil
        instance.organization_id = nil
        instance.save!
        Organization.count.should == 0
      end
    end
  end
end
