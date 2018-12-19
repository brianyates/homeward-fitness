class ContestantsController < ApplicationController
	def invite
		@contestant = Contestant.new(inviter_id: current_user.id, contest_id: params[:contest_id], user_id: params[:user_id], status: 0) if current_user
		if @contestant && @contestant.save
			ContestInviteJob.perform_later(current_user, params[:user_id], @contestant.contest_id)
			respond_to do |format|
				format.js
				format.html
			end
		end
	end
	
	def accept
		@contestant = Contestant.where(user_id: current_user.id, contest_id: params[:contest_id], status: 0).first if current_user
		if @contestant && @contestant.update(status: 2)
			flash[:notice] = "Contest joined!"
			redirect_to "/contests/#{params[:contest_id]}"
		end
	end
	
	def decline
		@contestant = Contestant.where(user_id: current_user.id, contest_id: params[:contest_id], status: 0).first if current_user
		if @contestant && @contestant.update(status: 1)
			@contest_count = contest_requests
			respond_to do |format|
				format.js
				format.html
			end
		end
	end
end