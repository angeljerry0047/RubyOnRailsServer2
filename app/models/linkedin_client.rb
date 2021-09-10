class LinkedinClient
  attr_reader :client
  delegate :connections, :to => :client
  delegate :send_message, :to => :client

  def initialize(user)
    @user   = user
    @client = LinkedIn::Client.new(LINKED_IN_API.fetch('consumer_key'), LINKED_IN_API.fetch('consumer_secret'))

    if user.access_key && user.access_secret
      @client.authorize_from_access(user.access_key, user.access_secret)
    else
      # FIXME (cmhobbs+tyreldenison) raise a custom error here
      raise 'You must re-sync with linkedin'
    end
  end

  def connections(start = 0, count = 10)
    params = {
      :start => start, 
      :count => count
    }

    Rails.cache.fetch(params.inspect + "user_id:#{@user.uid}", :expires_in => 7.days) do
      self.client.connections(params)
    end
  end

  # FIXME (cmhobbs+tyreldenison) make this a constant
  def self.linkedin_fields
    [
      'description',
      'website-url',
      'industries',
      'status',
      'name',
      'employee-count-range',
      'company-type',
      'founded-year',
      'locations'
    ].freeze
  end

  def company(options = {})
    @client.company(options.merge(:fields => self.class.linkedin_fields))
  end

  def company_search(keywords)
    path = "/company-search?keywords=#{URI.escape(keywords)}"
    Array(@client.public_send(:simple_query, path).companies.all)
  end

  def self.differences_between(organization, response)

    response_hash = response_to_org_hash(response)
    changeset = {}

    response_hash.each do |k,v|
      changeset[k] = v if response_hash[k] != organization[k]
    end

    changeset
  end

  def self.response_to_org_hash(response)
    org_hash = {
      'title'            => response.name,
      'description'      => response.description,
      'website'          => response.website_url,
      'company_type'     => response.company_type.name,
      'operating_status' => response.status.name,
      'year_founded'     => response.founded_year,
    }

    employee_min, employee_max   = extract_employee_range(response)
    org_hash['company_size_min'] = employee_min
    org_hash['company_size_max'] = employee_max

    org_hash = org_hash.merge(extract_location(response))

    industry = Array(response.industries.all).first || NullObject.new

    if Industry.exists?(:naics_code => industry.code)
      org_hash['industry_id'] = Industry.where(:naics_code => industry.code).first.id
    end

    org_hash
  end

  # Taken from http://developer.linkedin.com/documents/company-lookup-api-and-fields
  # A:1
  # B: 2-10
  # C: 11-50
  # D: 51-200
  # E: 201-500
  # F: 501-1000
  # G: 1001-5000
  # H: 5001-10,000
  # I: 10,000+
  def self.extract_employee_range(response)
    mapping = {
      "A" => [0, 1],
      "B" => [2, 10],
      "C" => [11, 50],
      "D" => [51, 200],
      "E" => [201, 500],
      "F" => [501, 1000],
      "G" => [1001, 5000],
      "H" => [5001, 10_000],
      "I" => [10_001, nil]
    }

    mapping.fetch(response.employee_count_range.code) { [nil,nil] }
  end

  def self.extract_location(response)
    if response.locations.total > 0
      location = response.locations.all.first
      address = location.address || NullObject.new

      {
        'address1' => address.street1,
        'address2' => address.street2,
        'city' => address.city,
        'zipcode' => address.postal_code
      }
    else
      {}
    end
  end

end
