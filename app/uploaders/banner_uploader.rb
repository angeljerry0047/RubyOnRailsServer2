class BannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fill: [851, 315]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*_args)
    ActionController::Base
      .helpers
      .asset_path('fallback/' + [version_name, 'missing_avatar1.png'].compact.join('_'))
  end
end
