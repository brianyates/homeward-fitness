class EarnedBadge < ApplicationRecord
	validates :user_id, presence: true, uniqueness: {scope: :badge_id}
end
