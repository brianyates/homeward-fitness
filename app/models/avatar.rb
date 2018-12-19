class Avatar < ApplicationRecord
	mount_uploader :image, AvatarUploader
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	validate :user_or_instructor
	after_update :crop
	
	private
	def crop
		if self.crop_x.present?
			self.image.recreate_versions!
			if self.avatar_type == 0 
				User.where(id: self.user_id).update(image_path: self.image.thumb.url)
			else
				Instructor.where(id: self.instructor_id).update(image_path: self.image.thumb.url)
			end
			DeleteAvatarsJob.perform_later(self)
		end
	end
	
	def user_or_instructor
		errors.add("Avatar", "must have user associated with it") unless (self.user_id.present? || self.instructor_id.present?)
	end
end
