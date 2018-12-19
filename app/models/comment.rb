class Comment < ApplicationRecord
	validates :user_id, presence: true
	validates :thing_id, presence: true
	validates :comment, presence: true, length: { maximum: 251 }
	before_destroy :delete_likes_and_replies

	def reply_count
		Reply.where(comment_id: self.id).count
	end
	def like_count
		CommentLike.where(comment_id: self.id).count
	end
	def delete_likes_and_replies
		Reply.where(comment_id: self.id).delete_all
		CommentLike.where(comment_id: self.id).delete_all
	end
end
