require 'spec_helper'
class FaultyUser < ActiveRecord::Base
  self.table_name = :users
  validate :foo
  
  def foo
    errors.add(:base, "ZOMG THIS IS CRAZY YO")
  end
end


describe ApplicationHelper do
  
  it 'displays no errors when no errors' do
    user = FactoryBot.create(:professional)
    display_base_errors(user).should be_blank
  end
  
  it 'displays paragraphs for errors' do
    f = FaultyUser.new
    f.valid?
    expected = bootstrap_alert("<p>Base zomg this is crazy yo</p>".html_safe)
    display_base_errors(f).should == expected
  end
  
  it 'sends a bootstrap specific alert' do
    expected = "<div class=\"alert alert-error alert-block\"><button class=\"close\" data-dismiss=\"alert\" type=\"button\">&#215;</button>zomg</div>"
    bootstrap_alert("zomg").should == expected
  end
  
  
  %w[site_title site_description].each do |t| 
    it "has a #{t}" do
      send(t).should == Serve2perform::Application.config.site_title
      Serve2perform::Application.config.site_title = 'NEW'
      send(t).should == 'NEW'
    end
  end
  
  context 'selected' do
    let (:competencies) { FactoryBot.create_list(:competency, 2) }
    let (:user) do
      user = FactoryBot.create(:professional)
      user.competencies << competencies.first
      user
    end
    
    
    it "is selected if the competency is in the children" do
      selected?(user, competencies.first).should == 'selected'
      selected?(user, competencies.last).should == ''
    end
    
    it 'should have nothing selected' do
      competencies.each do |comp|
        selected?(nil, comp).should == ''
      end
    end
  end
end
