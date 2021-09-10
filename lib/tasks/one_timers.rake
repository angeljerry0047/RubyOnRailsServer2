namespace :one_timers do
  desc "update BestPracticeCategory recommendables"
  task update_best_practice_categories: :environment do
    # hide unwanted categories
    titles = ["Ambassador", "Job Shadow Host", "Volunteer"]
    BestPracticeCategory.where(title: titles).update_all(recommendable: false)
    p "BestPracticeCategories Ambassador, Job Shadow Host, Volunteer hidden"

    # create new categories 
    category = BestPracticeCategory.new
    category.title = "Teacher"
    category.recommendable = true
    category.save
    p "BestPractice Category #{category.title} created"

    category = BestPracticeCategory.new
    category.title = "Coach"
    category.recommendable = true
    category.save
    p "BestPractice Category #{category.title} created"

    category = BestPracticeCategory.new
    category.title = "Sponsor"
    category.recommendable = true
    category.save
    p "BestPractice Category #{category.title} created"
  end

  desc "update current certifications"
  task update_current_certifications: :environment do
    # update existing certifications
    certs = ["Mentor", "Board Member"]
    CertificationType.where(name: certs).update_all(awardable: true)

    # create new certifications
    cert = CertificationType.create(name: "Teacher", awardable: true)
    p "Certification Type #{cert.name} created"

    cert = CertificationType.create(name: "Coach", awardable: true)
    p "Certification Type #{cert.name} created"

    cert = CertificationType.create(name: "Sponsor", awardable: true)
    p "Certification Type #{cert.name} created"
  end
end