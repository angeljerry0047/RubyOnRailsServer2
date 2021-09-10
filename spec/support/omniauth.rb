def set_omniauth(opts = {})
  default = {
    provider: :linkedin,
    uuid:     "1234",
    linkedin: {
      email:      "foobar@example.com",
      gender:     "Male",
      first_name: "foo",
      last_name:  "bar"
    }
  }
 
  credentials = default.merge(opts)
  provider    = credentials[:provider]
  user_hash   = credentials[provider]
 
  OmniAuth.config.test_mode = true
 
  OmniAuth.config.mock_auth[provider] = YAML::load_file(Rails.root.join("./spec/fixtures/linked_in_test.yml"))
end
 
def set_invalid_omniauth(opts = {})
 
  credentials = { 
    :provider => :facebook,
    :invalid  => :invalid_crendentials
  }.merge(opts)
 
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
 
end