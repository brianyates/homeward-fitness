class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  # Process files as they are uploaded:
	process resize_to_limit: [550, 550]
	process :orient
	
	version :thumb, if: :is_workout?
	version :thumb do
		process resize_to_fill: [64,64]
	end

  # Add a white list of extensions which are allowed to be uploaded.
	def extension_whitelist
		%w(jpg jpeg gif png)
	end
	def orient
		manipulate! do |img|
			img = img.auto_orient
		end
	end


	private
	def is_workout? image
		model.class.to_s == 'Workout'
	end
end
