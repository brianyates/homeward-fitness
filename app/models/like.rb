class Like < ApplicationRecord
	validates :user_id, presence: true
	validates :thing_id, presence: true, uniqueness: {scope: :user_id}
end
