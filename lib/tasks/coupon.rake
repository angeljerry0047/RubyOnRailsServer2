namespace :assessment_codes  do
  desc "Create a new assessment code"
  task :create, [:code, :company_id, :amount] => :environment do |t, args|
    Coupon.create(:code => args.code, :organization_id => args.company_id, :limit => args.amount)
  end
end