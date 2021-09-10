# competencies = <<-YAML
# ---
# - Management
# - - Authentic Leadership
# - - Change Management
# - - Project Management
# - - Executive Presence
# - Adaptability
# - Business Acumen
# - Communications
# - - Public Relations
# - - Public Speaking
# - - Emotional Intelligence
# - Leadership
# - - Strategic Thinking
# - Critical Thinking
# - Cross-Cultural
# - Competencies
# - Customer Service
# - Engagement
# - Finance & Accounting
# - Legal Savvy
# - Negotiation
# - - Influence
# - - Marketing
# - Political Savvy
# - Relationship
# - Sales
# - Succession Planning
# - - Talent
#   - Talent Acquisition
#   - Talent Development
#   - Talent Management
# - Team Builder
# - Visionary
# YAML

Competency.delete_all
QuestionGroup.find_each do |qg|
  qg.competencies = []
  qg.save!
end

competencies = ["Authentic leadership", "Negotiation", "Emotional intelligence", "Relationship management", "Executive presence", "Team building", "Visionary", "Sales", "Communication", "Public relations", "Political savvy", "Agile", "Self-awareness", "Customer service", "Adaptability", "Change management", "High Network Quotient", "Complex Problem Solving", "Decision Making", "Attentive Listener", "Collaborative and Inclusive", "Mission-Minded", "Purpose-Driven", "Pace Setter", "Cross-cultural competency", "Critical Thinking", "Marketing", "Public Speaking", "Proficient Generalist", "Metrics and Evaluation", "Strategic thinking", "Public speaking", "Critical thinking", "Talent development", "Talent Management", "Emotional Intelligence", "Succession planning", "Legal savvy", "Business Acumen", "Pace-Setter", "Strategic Thinking", "Project management", "High Nework Quotient", "Finance and accounting"]
competencies.each do |comp|
  if Competency.exists?(:name => comp.capitalize.strip.gsub("-", " "))
    # skip
  else
    Competency.create!(:name => comp.capitalize.strip.gsub("-", " "))
  end
end


# parse_tree(competencies, Competency)


CSV.foreach(Rails.root.join("./db/linkedin_industries.csv"), :headers => true) do |csv|
  next if csv.empty?
  if Industry.exists?(:naics_code => csv['Code'])
    
  else
    Industry.create!(:naics_code => csv['Code'], :title => csv['Description'])
  end
end

CSV.foreach(Rails.root.join('./db/assessment_questions.csv'), :headers => true) do |csv|
  
  group = QuestionGroup.find_or_create_by(name: csv['group'])
  obj = {:text => csv['text']}
  
  if !Question.exists?(obj)
    q = Question.create(obj)
    group.questions << q
    group.save!
  else
    next
  end
end

if !Assessment.exists?(:title => "PerformanceGPA Assessment Individual Report")
  Assessment.create!(:title => "PerformanceGPA Assessment Individual Report", :price => 125.00)
end

ass = Assessment.find_by_title("PerformanceGPA Assessment Individual Report")
ass.question_groups = QuestionGroup.all
ass.save!


CSV.foreach(Rails.root.join('./db/competency_question_groups.csv'), :headers => true) do |csv|
  if !Competency.exists?(:name => csv['competency'].capitalize.strip.gsub("-", " "))
    competency = Competency.create!(:name => csv['competency'].capitalize.strip.gsub("-", " "))
  else
    competency = Competency.find_by_name(csv['competency'].capitalize.strip.gsub("-", " "))
  end
  
  group = QuestionGroup.find_by_name(csv['question_group'])
  CompetenciesQuestionGroup.create!(:question_group_id => group.id, :competency_id => competency.id, :rating_bucket => csv['gpa_name'])
end

CSV.foreach(Rails.root.join("./db/competency_descriptions.csv"), :headers => true) do |csv|
  name = csv['competency_name'].capitalize.strip.gsub("-", " ")
  if !Competency.exists?(:name => name)
    throw "#{csv['competency_name']} doesnt exist"
  else
    competency = Competency.find_by_name(name)
  end
  
  competency.description = csv['description']
  competency.save!
end

if Competency.where(:description => "").count != 0 
  throw "There are competencies without descriptions"
end
