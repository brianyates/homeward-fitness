class Staging < ApplicationRecord
	validates :email, presence: true
	validates :user_id, presence: true
	validate :check_email
    before_save { |staging| staging.email = staging.email.downcase }
	
	private
	def check_email
		@email = User.find_by_email(self.email)
		if @email
			errors.add("There's already", "an account with this email address.")
		else
			@staging = Staging.where(email: self.email, user_id: self.user_id).first
			errors.add("You've already", "sent an invite to this email address.") if @staging
		end
	end
end
