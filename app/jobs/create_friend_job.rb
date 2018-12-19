class CreateFriendJob < ApplicationJob
	queue_as :default
	def perform(init_user, init_friend_id, init_id, email_request)
		@f_2 = Friend.new(user_id: init_friend_id, friend_id: init_user.id, paired_record: init_id, email_request: email_request)
		Friend.find(init_id).update(paired_record: @f_2.id) if @f_2.save
		@user = User.joins("JOIN email_preferences ON email_preferences.user_id = users.id").select(:id, :email, :name, :token_1, :token_2, :friend_requests, :email_validated).where(id: init_friend_id).first
		MainMailer.friend_request_with_account(@user, init_user.name).deliver_now if (@user && @user.friend_requests == 1 && @user.email_validated == true)
	end
end
