class ContestInviteJob < ApplicationJob
	queue_as :default
	#This job will alert the user when they've been invited to a contest
	def perform(inviter, user_id, contest_id, email = nil)
		@inviter = inviter
		@user = User.joins("JOIN email_preferences ON email_preferences.user_id = users.id").select(:id, :email, :name, :token_1, :token_2, :contest_invitation, :email_validated).where(id: user_id).first
		if @user
			@contest = Contest.find(contest_id)
			MainMailer.contest_invite_with_account(@user, @inviter.name, @contest.contest_title).deliver_now if (@user.contest_invitation == 1 && @user.email_validated == true)
		else
			MainMailer.contest_invite_no_account(email, @inviter.name, @contest.contest_title).deliver_now
		end
	end
end
