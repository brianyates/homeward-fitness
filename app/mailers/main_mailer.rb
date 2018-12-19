class MainMailer < ApplicationMailer
	def welcome_with_verification(user, token, tid)
		@user = user
		@email = @user.email
		@token = token
		@tid = tid
		@email_domain = ENV["DOMAIN_VALUE"]
		mail( :to => @email,  :subject => "Welcome to Homeward Fitness - Please Verify Your Email" )
	end
	def welcome_without_verification(user)
		@user = user
		@email = @user.email
		@email_domain = ENV["DOMAIN_VALUE"]
		mail( :to => @email,  :subject => "Welcome to Homeward Fitness!" )
	end
	def friend_request_with_account(user, requestor)
		@user = user
		@email = @user.email
		@requestor = requestor
		@token_1 = @user.token_1
		@token_2 = @user.token_2
		@email_domain = ENV["DOMAIN_VALUE"]
		mail( :to => @email,  :subject => "#{@requestor} wants to be your Fitness Friend" )
	end
	def friend_request_no_account(email, requestor)
		@email = email
		@requestor = requestor
		@email_domain = ENV["DOMAIN_VALUE"]
		mail( :to => @email,  :subject => "#{@requestor} has invited you to join Homeward Fitness" )
	end
	def new_contact_us(name, email)
		@email_domain = ENV["DOMAIN_VALUE"]
		@name = name
		@email = email
		mail( :to => 'support@homewardfitness.com',  :subject => "Someone contacted us" )
	end
	def account_recovery(user, token, tid)
		@email_domain = ENV["DOMAIN_VALUE"]
		@user = user
		@email = @user.email
		@token = token
		@tid = tid
		mail( :to => @email,  :subject => "Password Reset Requested" )
	end
	def password_reset_successful(user)
		@email_domain = ENV["DOMAIN_VALUE"]
		@user = user
		@email = @user.email
		mail( :to => @email,  :subject => "Password Reset Successful" )
	end
	def post_liked(recipient, user, post_id)
		@email_domain = ENV["DOMAIN_VALUE"]
		@recipient = recipient
		@email = @recipient.email
		@user = user
		@token_1 = @recipient.token_1
		@token_2 = @recipient.token_2
		@post_id = post_id
		mail( :to => @email,  :subject => "#{@user.name} liked your workout" )
	end
	def post_commented_on(recipient, user, post_id, comment)
		@email_domain = ENV["DOMAIN_VALUE"]
		@recipient = recipient
		@token_1 = @recipient.token_1
		@token_2 = @recipient.token_2
		@email = @recipient.email
		@user = user
		@post_id = post_id
		@comment = comment
		mail( :to => @email,  :subject => "#{@user.name} commented on your workout" )
	end
	def comment_reply(recipient, user, comment, reply, redirect_url)
		@email_domain = ENV["DOMAIN_VALUE"]
		@recipient = recipient
		@token_1 = @recipient.token_1
		@token_2 = @recipient.token_2
		@email = @recipient.email
		@user = user
		@comment = comment
		@reply = reply
		@redirect_url = redirect_url
		mail( :to => @email,  :subject => @user.name + ' replied to your comment: "' + @comment + '"' )
	end
	def invite_owner(user, instructor, token_id, token)
		@email_domain = ENV["DOMAIN_VALUE"]
		@user = user
		@email = @user.email
		@instructor = instructor
		@token_id = token_id
		@token = token
		mail( :to => @email, :subject => "Invitation to Manage #{@instructor.instructor_name}'s Instructor Account on Homeward Fitness")
	end
	def contest_invite_with_account(user, inviter, contest_title)
		@email_domain = ENV["DOMAIN_VALUE"]
		@user = user
		@token_1 = @user.token_1
		@token_2 = @user.token_2
		@email = @user.email
		@inviter = inviter
		@contest_title = contest_title
		mail( :to => @email, :subject => "Homeward Fitness Contest Invitation - #{@contest_title}")
	end
	def contest_invite_no_account(email, inviter, contest_title)
		@email_domain = ENV["DOMAIN_VALUE"]
		@email = email
		@inviter = inviter
		@contest_title = contest_title
		mail( :to => @email, :subject => "#{@inviter} has invited you to join a Homeward Fitness Contest")
	end
	def badge_earned(user, badge)
		@email_domain = ENV["DOMAIN_VALUE"]
		@user = user
		@token_1 = @user.token_1
		@token_2 = @user.token_2
		@email = @user.email
		@badge = badge
		mail( :to => @email, :subject => "You've just earned the #{@badge.badge_name} Badge!")
	end
	def top_performance(performance, email_pref)
		@email_domain = ENV["DOMAIN_VALUE"]
		@performance = performance
		@token_1 = email_pref.token_1
		@token_2 = email_pref.token_2
		@email = @performance.email
		mail( :to => @email, :subject => "You had the top performance for one of our Weekly Workouts!")
	end
	def leaderboard_podium(top_performers, user, email_pref)
		@email_domain = ENV["DOMAIN_VALUE"]
		@user = user
		@token_1 = email_pref.token_1
		@token_2 = email_pref.token_2
		@email = @user.email
		@top_performers = top_performers
		mail( :to => @email, :subject => "You got #{@user.rank.ordinalize} place on this week's Leaderboard!")
	end
	def contest_completed(top_performers, contest, user)
		@email_domain = ENV["DOMAIN_VALUE"]
		@user = user
		@token_1 = @user.token_1
		@token_2 = @user.token_2
		@email = @user.email
		@top_performers = top_performers
		@contest = contest
		mail( :to => @email, :subject => "Fitness Contest '#{@contest.contest_title}' is complete! How'd you do?")
	end
	def contest_comment(recipient, user, contest, comment)
		@email_domain = ENV["DOMAIN_VALUE"]
		@recipient = recipient
		@token_1 = @recipient.token_1
		@token_2 = @recipient.token_2
		@email = @recipient.email
		@user = user
		@contest = contest
		@comment = comment
		mail( :to => @email,  :subject => "#{@user.name} posted a comment in the contest '#{@contest.contest_title}'" )
	end
end
