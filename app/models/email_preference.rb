class EmailPreference < ApplicationRecord
	validates :contest_info, :contest_invitation, :new_badge, :contest_comments, :leaderboard, :friend_requests, :post_info, :comment_replies, presence: true
end
