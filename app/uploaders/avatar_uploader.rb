class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :auto_orient # this should go before all other "process" steps
  process resize_to_fill: [120, 120]

  def extension_white_list
    %w[jpg jpeg gif png]
  end

  version :thumb do
    # process resize_and_crop: 100
    process resize_to_fill: [100, 100]
  end

  version :wide do
    process resize_to_limit: [150, nil]
  end

  # def default_url(*_args)
  #   'missing-avatar1.png'
  # end

  def default_url(*_args)
    ActionController::Base
      .helpers
      .asset_path('fallback/' + [version_name, 'missing_avatar1.png'].compact.join('_'))
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  private

  # Simplest way
  def crop(geometry)
    manipulate! do |img|
      img.crop(geometry)
      img
    end
  end

  # Resize and crop square from Center
  def resize_and_crop(size)
    manipulate! do |image|
      Rails.logger.error '----------- image:'
      Rails.logger.error image.inspect

      if image[:width] < image[:height]
        remove = ((image[:height] - image[:width]) / 2).round
        image.shave("0x#{remove}")
      elsif image[:width] > image[:height]
        remove = ((image[:width] - image[:height]) / 2).round
        image.shave("#{remove}x0")
      end
      image.resize("#{size}x#{size}")
      image
    end
  end

  def auto_orient
    manipulate! do |image|
      Rails.logger.error '----------- image:'
      Rails.logger.error image.inspect

      image.tap(&:auto_orient)
    end
  end
end
