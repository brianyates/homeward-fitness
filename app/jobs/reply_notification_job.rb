class ReplyNotificationJob < ApplicationJob
	queue_as :default
	#This job will alert the user their comment was replied to, but only once (repeat comments from the same user will not create notifications)
	def perform(reply, user)
		@user = user
		@reply = reply
		@comment = Comment.where(id: @reply.comment_id).joins("JOIN things ON things.id = comments.thing_id").select(:user_id, :thing_type, :id, :comment, :thing_id).first
		unless @comment.user_id == @user.id
			@reply_email = ReplyEmail.where(comment_id: @comment.id, user_id: @user.id, recipient_id: @comment.user_id).first
			unless @reply_email.present?
				@recipient = User.joins("JOIN email_preferences ON email_preferences.user_id = users.id").select(:id, :email, :name, :token_1, :token_2, :comment_replies, :email_validated).where(id: @comment.user_id).first
				(@comment.comment.length > 40) ? (@comment_val = @comment.comment[0,40] + "...") : (@comment_val = @comment.comment)
				if @comment.thing_type == 0 #thing_type == 0 means it's for the leaderboard
					@action = send_notification("/leaderboard")
				elsif @comment.thing_type == 1 #thing_type == 1 means it's for a user's post
					@post = Post.find_by_thing_id(@comment.thing_id)
					@action = send_notification("/posts/#{@post.id}")
				elsif @comment.thing_type == 2 #thing_type == 2 means it's for a workout
					@workout = Workout.find_by_thing_id(@comment.thing_id)
					@action = send_notification("/workouts/#{@workout.id}")
				elsif @comment.thing_type == 3 #thing_type == 3 means it's for a contest
					@contest = Contest.find_by_thing_id(@comment.thing_id)
					@action = send_notification("/contests/#{@contest.id}")
				end
				ReplyEmail.create(comment_id: @comment.id, user_id: @user.id, recipient_id: @comment.user_id)
			end
		end
	end
	
	private
	def send_notification(redirect_url)
		Alert.create!(user_id: @recipient.id, message: (@user.name + ' replied to your comment: "' + @comment_val + '"'), redirect_url: redirect_url, image_user: @user.id)
		MainMailer.comment_reply(@recipient, @user, @comment_val, @reply.comment, redirect_url).deliver_now if (@recipient.comment_replies == 1 && @recipient.email_validated == true)
		true
	end
end
