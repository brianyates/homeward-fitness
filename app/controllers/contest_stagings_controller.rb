class ContestStagingsController < ApplicationController
	def invite_by_email
		if current_user
			@user = User.find_by_email(params[:contest_staging][:email])
			if @user
				@contestant = Contestant.new(inviter_id: current_user.id, contest_id: params[:contest_id], user_id: @user.id, status: 0)
				ContestInviteJob.perform_later(current_user, @user.id, params[:contest_id]) if @contestant.save
			else
				@contest_staging = ContestStaging.new(inviter_id: current_user.id, email: params[:contest_staging][:email], contest_id: params[:contest_id])
				ContestInviteJob.perform_later(current_user, 0, params[:contest_id], params[:contest_staging][:email]) if @contest_staging.save
			end
		end
		respond_to do |format|
			format.html
			format.js
		end
	end
end