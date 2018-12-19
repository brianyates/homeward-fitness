class CommentLike < ApplicationRecord
	validates :comment_id, presence: true, uniqueness: {scope: :user_id}
	validates :user_id, presence: true
end
