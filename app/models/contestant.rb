class Contestant < ApplicationRecord
	validates :user_id, presence: true, uniqueness: {scope: :contest_id}
	validates :contest_id, presence: true
end
