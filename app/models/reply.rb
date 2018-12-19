class Reply < ApplicationRecord
	validates :comment_id, presence: true
	validates :user_id, presence: true
	validates :comment, presence: true, length: {maximum: 251}
	before_destroy :delete_likes
	
	def like_count
		ReplyLike.where(reply_id: self.id).count
	end
	def delete_likes
		ReplyLike.where(reply_id: self.id).delete_all
	end
end
