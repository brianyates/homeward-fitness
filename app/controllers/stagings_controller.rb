class StagingsController < ApplicationController
	def create
		if current_user && current_user.email != params[:staging][:email]
			@user = User.find_by_email(params[:staging][:email])
			if @user
				@friend = Friend.new(user_id: current_user.id, friend_id: @user.id, status: 1, email_request: true)
				if @friend.save
					CreateFriendJob.perform_later(current_user, @user.id, @friend.id, true)
					flash[:notice] = "Friend request sent!"
				else
					flash[:alert] = "Error - " + @friend.errors.full_messages[0]
				end
			else
				@staging = Staging.new(params.require(:staging).permit(:email).merge(user_id: current_user.id))
				if @staging && @staging.save
					MainMailer.friend_request_no_account(@staging.email, current_user.name).deliver_later
					flash[:notice] = "Friend request sent!"
				else
					flash[:alert] = "Error -  " + @staging.errors.full_messages[0]
				end
			end
		else
			flash[:alert] = "You're already your own friend!"
		end
		redirect_back fallback_location: "/weekly-workouts"
	end
end
