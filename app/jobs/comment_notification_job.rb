class CommentNotificationJob < ApplicationJob
	queue_as :default
	#This job will alert the user their post was commented on, but only once (repeat comments will not create notifications)
	def perform(thing_id, user, comment)
		@thing = Thing.find(thing_id)
		@user = user
		if @thing.thing_type == 1 #user post
			@post = Post.find_by_thing_id(@thing.id)
			unless @post.user_id == @user.id
				@thing_email = ThingEmail.where(thing_id: @thing.id, user_id: @user.id, recipient_id: @post.user_id, category: 1).first
				unless @thing_email.present?
					@recipient = User.joins("JOIN email_preferences ON email_preferences.user_id = users.id").select(:id, :email, :name, :token_1, :token_2, :post_info, :email_validated).where(id: @post.user_id).first
					Alert.create!(user_id: @recipient.id, message: "#{@user.name} commented on your post", redirect_url: "/posts/#{@post.id}", image_user: @user.id)
					MainMailer.post_commented_on(@recipient, @user, @post.id, comment).deliver_now if (@recipient.post_info == 1 && @recipient.email_validated == true)
					ThingEmail.create(thing_id: @thing.id, user_id: @user.id, recipient_id: @post.user_id, category: 1)
				end
			end
		elsif @thing.thing_type == 3 #contest
			@contest = Contest.find_by_thing_id(@thing.id)
			@contestants = Contestant.joins("JOIN users ON users.id = contestants.user_id JOIN email_preferences ON email_preferences.user_id = users.id").where(contest_id: @contest.id, status: 2).select(:user_id, :name, :email, :token_1, :token_2, :email_validated, :contest_comments)
			@contestants.each do |c|
				unless @user.id == c.user_id
					Alert.create!(user_id: c.user_id, message: "#{@user.name} posted a comment in the contest '#{@contest.contest_title}'", redirect_url: "/contests/#{@contest.id}", image_user: @user.id)
					MainMailer.contest_comment(c, @user, @contest, comment).deliver_now if (c.contest_comments == 1 && c.email_validated == true)
				end
			end
		end
	end
end
