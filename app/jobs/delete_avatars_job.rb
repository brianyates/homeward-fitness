class DeleteAvatarsJob < ApplicationJob
	queue_as :default
	def perform(avatar)
		if avatar.avatar_type == 0
			@avatars = Avatar.where('user_id = ? AND id != ?', avatar.user_id, avatar.id)
		else
			@avatars = Avatar.where('instructor_id = ? AND id != ?', avatar.instructor_id, avatar.id)
		end
		@avatars.each do |a|
			a.remove_avatar!
			a.destroy!
		end
	end
end
