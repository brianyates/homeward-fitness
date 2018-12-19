class Friend < ApplicationRecord
	attr_accessor :email_request
	validates :user_id, presence: true
	validates :friend_id, presence: true, uniqueness: {scope: :user_id}
	validate :must_be_unique
	
	private
	def must_be_unique
		if self.email_request
			@friend = Friend.where(user_id: self.user_id, friend_id: self.friend_id).first
			if @friend
				if @friend.status == 2
					errors.add("You two", "are already friends.")
				else
					errors.add("You've already", "sent this person a request.")
				end
			end
		end
	end
end
