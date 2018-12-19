class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  def store_dir
    "avatar_type_#{model.avatar_type}/#{model.id}"
  end

  # Process files as they are uploaded:
	process resize_to_limit: [600, 600]
	process :orient

  # Create different versions of your uploaded files:
	version :thumb do
		process :crop
		process resize_to_fit: [200, 200]
	end
	
	def crop
		if model.crop_x.present?
			manipulate! do |img|
				img.crop("#{model.crop_w}x#{model.crop_h}+#{model.crop_x}+#{model.crop_y}")
			end
		end
	end
	def orient
		manipulate! do |img|
			img = img.auto_orient
		end
	end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
	def extension_whitelist
		%w(jpg jpeg gif png)
	end

end
