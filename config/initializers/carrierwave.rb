require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'us-west-2'
    }

    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_directory  = ENV['AWS_S3_BUCKET']
    config.fog_public     = false
    config.fog_authenticated_url_expiration = 600
    config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  else
    config.storage = :file
  end
end
