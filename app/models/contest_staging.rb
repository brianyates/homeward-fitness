class ContestStaging < ApplicationRecord
    before_save { |c| c.email = c.email.downcase }
	validates :email, presence: true, uniqueness: {case_sensitive: false, scope: :contest_id}
end
