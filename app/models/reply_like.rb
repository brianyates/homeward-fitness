class ReplyLike < ApplicationRecord
	validates :user_id, presence: true
	validates :reply_id, presence: true, uniqueness: {scope: :user_id}
end
