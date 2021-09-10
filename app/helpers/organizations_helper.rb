module OrganizationsHelper
  require 'chronic'

  # TODO (cmhobbs) DRY up this code and add unit tests

  # Divine time based data directly from models without any
  # complicated associations (MentorshipCircles, FastContents, etc.),
  # scoped by Organization.
  #
  # model_name   = The Constant to be polled.
  # organization = The Organization object for scoping.
  # start_time   = A natural language String for the start time.
  # end_time     = A natural language String for the end time.
  #
  # Examples
  #
  #   direct_stats(CollaborationCircle, #<Organization ...>, "7 days ago", "today")
  #   # =>  [ { <Mon, 12 Sep 2016> => 0 },
  #           { <Tue, 13 Sep 2016> => 0 },
  #           { <Wed, 14 Sep 2016> => 0 },
  #           { <Thu, 15 Sep 2016> => 1 },
  #           { <Fri, 16 Sep 2016> => 0 },
  #           { <Sat, 17 Sep 2016> => 0 },
  #           { <Sun, 18 Sep 2016> => 0} ]
  #
  # Returns an Array of Hashes containing Date objects mapped
  # to Object counts.
  def direct_stats(model_name, organization, start_time, end_time)

    parsed_start_time = parse_time(start_time)
    parsed_end_time   = parse_time(end_time)

    # NOTE (cmhobbs) Object#tap would probalby clean this up
    records_by_date = Hash[
      model_name.where(organization_id: organization.id)
      .select('DATE(created_at) created_at, count(id) as id')
      .group('DATE(created_at)')
      .map{ |record| [record.created_at.to_date, record.id] }
    ]

    parsed_start_time.upto(parsed_end_time).map do |date|
      { date: date, value: records_by_date[date] || 0 }
    end
  end
  
  # Divine time based data for Opportunities by OpportunityCategory,
  # scoped by Organization.
  #
  # category_id  = The Integer representing the OpportunityCategory ID.
  # organization = The Organization object for scoping.
  # start_time   = A natural language String for the start time.
  # end_time     = A natural language String for the end time.
  #
  # Examples
  #
  #   opportunity_stats(18, "7 days ago", "today")
  #   # =>  [ { <Mon, 12 Sep 2016> => 0 },
  #           { <Tue, 13 Sep 2016> => 0 },
  #           { <Wed, 14 Sep 2016> => 0 },
  #           { <Thu, 15 Sep 2016> => 1 },
  #           { <Fri, 16 Sep 2016> => 0 },
  #           { <Sat, 17 Sep 2016> => 0 },
  #           { <Sun, 18 Sep 2016> => 0} ]
  #
  # Returns an Array of Hashes containing Date objects mapped
  # to Object counts.
  def opportunity_stats(category_id, organization, start_time, end_time)
    
    parsed_start_time = parse_time(start_time)
    parsed_end_time   = parse_time(end_time)

    puts "=== fetch"
    # NOTE (cmhobbs) Object#tap would probalby clean this up
    records_by_date = Hash[
      OpportunityCategory.find(category_id).opportunities
      .where(organization_id: organization.id)
      .select('DATE(created_at) created_at, count(id) as id')
      .group('DATE(created_at)')
      .map{ |record| [record.created_at.to_date, record.id] }
    ]

    parsed_start_time.upto(parsed_end_time).map do |date|
      { date: date, value: records_by_date[date] || 0 }
    end
  end

  # Gather user counts per date on simple models.
  # Behaves like #direct_stats and #opportunity_stats
  def connections_for(model_name, organization, start_time, end_time)    
    parsed_start_time = parse_time(start_time)
    parsed_end_time   = parse_time(end_time)

    records_for_organization = model_name.where(organization_id: organization.id)
    requested_records = records_for_organization.where(created_at: parsed_start_time..parsed_end_time)

    connection_counts = Hash[requested_records.map { |record | [record.created_at, record.users.count] }]

    parsed_start_time.upto(parsed_end_time).map do |date|
      { date: date, value: connection_counts[0] || 0 }
    end
  end

  # Gather user counts per date on opportunities.
  # Behaves like #direct_stats and #opportunity_stats
  def connections_for_opportunity(category_id, organization, start_time, end_time)    
    parsed_start_time = parse_time(start_time)
    parsed_end_time   = parse_time(end_time)

    records_for_organization = OpportunityCategory.find(category_id).opportunities.where(organization_id: organization.id)
    requested_records = records_for_organization.where(created_at: parsed_start_time..parsed_end_time)

    connection_counts = Hash[requested_records.map { |record | [record.created_at, record.users.count] }]

    parsed_start_time.upto(parsed_end_time).map do |date|
      { date: date, value: connection_counts[0] || 0 }
    end
  end
  
  private

  def parse_time(time_string)
    Chronic.parse(time_string).to_date
  end
  
end
