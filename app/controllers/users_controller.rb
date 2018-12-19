class UsersController < ApplicationController

	def new
		if current_user
			redirect_to "/users/#{current_user.id}"
		else
			@user = User.new
		end
	end

	def create
		@user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			flash[:notice] = "Account Created - Welcome, #{@user.name.split(" ")[0]}!"
			redirect_back fallback_location: "/"
		else
			@error_msg = "Error - " + @user.errors.full_messages[0]
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def edit
		if current_user
			@user = current_user
			@avatar = Avatar.where(user_id: @user.id, avatar_type: 0).last
		end
	end
	
	def show
		@user = User.find_by_sql(["SELECT name, id, image_path, created_at,(SELECT COUNT(*) FROM posts WHERE posts.user_id = ?) AS workout_count, (SELECT SUM(posts.seconds) FROM posts WHERE posts.user_id = ?) AS total_time,
		(SELECT SUM(total_points) FROM posts JOIN results ON results.post_id = posts.id WHERE posts.user_id = ?) AS total_points FROM users WHERE users.id = ? AND (users.privacy_setting = 0 OR users.id = ? OR (users.id IN (SELECT friend_id FROM friends WHERE friends.user_id = ?) 
		AND users.privacy_setting = 1))", params[:id], params[:id], params[:id], params[:id], current_user.id, current_user.id]).first if current_user
		if @user
			(@user.created_at < Date.today - 365) ? (@cutoff_date = (Date.today - 365).to_date) : (@cutoff_date = @user.created_at.to_date)
			@recent_posts = Workout.find_by_sql(["SELECT posts.id AS post_id, workouts.workout_title, posts.workout_id, workouts.image, workouts.id AS id, (SELECT SUM(total_points) FROM results WHERE 
			results.post_id = posts.id) AS total_points, posts.created_at FROM posts INNER JOIN workouts ON workouts.id = posts.workout_id WHERE posts.user_id = ? 
			ORDER BY posts.created_at DESC LIMIT 10", params[:id]])
			@friend = Friend.where(user_id: current_user.id, friend_id: @user.id).select(:status, :id, :friend_id).first
			@friend_count = Friend.where(user_id: @user.id, status: 2).count
		end
	end
	
	def get_user_chart
		if params[:id].present? && params[:cutoff_date].present?
			@cutoff_date = params[:cutoff_date].to_date
			@zone = Time.now.in_time_zone.zone
			@chart_data = Post.find_by_sql(["WITH p AS (SELECT Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE '#{@zone}') AS post_date, SUM(results.total_points) AS total_points FROM posts
			INNER JOIN results ON results.post_id = posts.id WHERE posts.user_id = ? GROUP BY post_date), m AS (SELECT Date((posts.created_at AT TIME ZONE 'UTC') AT TIME ZONE '#{@zone}') AS post_date, 
			ROUND(SUM(seconds)/60.0, 1) AS total_minutes FROM posts WHERE posts.user_id = ? GROUP BY post_date),
			d AS (SELECT (GENERATE_SERIES(?, ?, '1 day'::interval))::date AS series_date)
			SELECT date_part('year', d.series_date)::int AS year, (date_part('month', d.series_date)::int - 1) AS month, date_part('day', d.series_date)::int AS day, COALESCE(p.total_points,0) AS total_points, 
			COALESCE(m.total_minutes,0) AS total_minutes, to_char(d.series_date, 'Mon DD, YYYY') AS date_value FROM d LEFT OUTER JOIN p ON p.post_date = d.series_date LEFT OUTER JOIN m ON
			m.post_date = d.series_date ORDER BY d.series_date", params[:id], params[:id], @cutoff_date, Date.today])
			@chart_data = @chart_data.map { |i| [i.year, i.month, i.day, i.total_minutes.to_f, i.total_points, i.date_value.to_s]}
			@totals = Post.find_by_sql(["SELECT (SELECT SUM(posts.seconds) FROM posts WHERE posts.user_id = ? AND posts.created_at AT TIME ZONE '#{@zone}' > (current_timestamp AT TIME ZONE '#{@zone}' - INTERVAL '6 days')) AS week_seconds,
			(SELECT COALESCE(SUM(posts.seconds),0) FROM posts WHERE posts.user_id = ? AND posts.created_at AT TIME ZONE '#{@zone}' > (current_timestamp AT TIME ZONE '#{@zone}' - INTERVAL '29 days')) AS month_seconds,
			(SELECT COALESCE(SUM(posts.seconds),0) FROM posts WHERE posts.user_id = ? AND posts.created_at AT TIME ZONE '#{@zone}' > (current_timestamp AT TIME ZONE '#{@zone}' - INTERVAL '364 days')) AS year_seconds,
			(SELECT COALESCE(SUM(total_points),0) FROM posts JOIN results ON results.post_id = posts.id WHERE posts.user_id = ? AND posts.created_at AT TIME ZONE '#{@zone}' > (current_timestamp AT TIME ZONE '#{@zone}' - INTERVAL '6 days')) AS week_points,
			(SELECT COALESCE(SUM(total_points),0) FROM posts JOIN results ON results.post_id = posts.id WHERE posts.user_id = ? AND posts.created_at AT TIME ZONE '#{@zone}' > (current_timestamp AT TIME ZONE '#{@zone}' - INTERVAL '29 days')) AS month_points,
			(SELECT COALESCE(SUM(total_points),0) FROM posts JOIN results ON results.post_id = posts.id WHERE posts.user_id = ? AND posts.created_at AT TIME ZONE '#{@zone}' > (current_timestamp AT TIME ZONE '#{@zone}' - INTERVAL '364 days')) AS year_points", 
			params[:id], params[:id], params[:id], params[:id], params[:id], params[:id]]).first
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def update
		if current_user
			@user = current_user
			if @user.update_attributes(user_params)
				flash[:notice] = "Changes saved successfully!"
			else
				flash[:alert] = "Error - " + @user.errors.full_messages[0]
			end
			redirect_to "/settings"
		end
	end
	
	def destroy
		if current_user
			@user = current_user
			if @user.destroy
				session[:user_id] = nil
				flash[:notice] = "Account deleted successfully."
			else
				flash[:alert] = "Something went wrong; please try again later."
			end
			redirect_to "/weekly-workouts"
		end
	end
	
	def update_password
		if current_user
			@user = current_user
			if @user.authenticate(password_params[:password_current])
				@user.password = password_params[:password_new]
				if @user.save
					flash[:notice] = "Password changed successfully!"
				else
					flash[:alert] = "An error occurred. Try again later."
				end
				redirect_to "/settings"
			else
				flash[:alert] = "Invalid current password."
				redirect_to "/change-password"
			end 
		end
	end
	
	def workouts
		if current_user 
			@posts = Post.find_by_sql(["SELECT workout_title, workout_type, workout_description, posts.video_url, posts.image, posts.thing_id, posts.user_id, 
			posts.created_at, posts.id, comment, name, email, image_path, rounds_and_reps, 
			(SELECT SUM(total_points) FROM results WHERE results.post_id = posts.id) AS total_points, (SELECT COUNT(*) FROM likes WHERE likes.thing_id = posts.thing_id) 
			AS like_count, (SELECT COUNT(*) FROM comments WHERE comments.thing_id = posts.thing_id) AS comment_count,
			workout_id, points_per_workout, seconds FROM posts JOIN workouts ON workouts.id = posts.workout_id JOIN users 
			ON users.id = posts.user_id WHERE posts.user_id = ? AND (users.privacy_setting = 0 OR posts.user_id = ? OR (posts.user_id IN (SELECT friend_id FROM friends WHERE friends.user_id = ?) AND users.privacy_setting = 1)) 
			ORDER BY posts.created_at DESC LIMIT 5", params[:id], current_user.id, current_user.id])
			@count = Post.joins("JOIN users ON users.id = posts.user_id").where("posts.user_id = ? AND (users.privacy_setting = 0 OR posts.user_id = ? OR (posts.user_id 
			IN (SELECT friend_id FROM friends WHERE friends.user_id = ?) AND users.privacy_setting = 1))", params[:id], current_user.id, current_user.id).count
			@timestamp = Time.now.to_f
		end
	end
	def workouts_table
		@items_per_page = 25
		@start = params[:start].to_i
		@start = 0 unless @start
		@count = Post.where("user_id = ?", params[:id]).count
		@posts = Workout.find_by_sql(["SELECT workout_title, workout_type, workout_description, posts.user_id, posts.created_at, posts.id AS post_id, users.image_path, 
		workouts.image, workouts.id AS ID, (SELECT SUM(total_points) FROM results WHERE results.post_id = posts.id) AS total_points, users.name, 
		workout_id FROM posts JOIN workouts ON workouts.id = posts.workout_id JOIN users ON users.id = posts.user_id WHERE posts.user_id = ?
		AND (users.privacy_setting = 0 OR posts.user_id = ? OR (posts.user_id IN (SELECT friend_id FROM friends WHERE friends.user_id = ?) AND users.privacy_setting = 1)) 
		ORDER BY posts.created_at DESC OFFSET ? LIMIT ?", params[:id], current_user.id, current_user.id, @start, @items_per_page]) if current_user
		@total_pages = (@count/@items_per_page.to_f).ceil
		@active_page = (@start/@items_per_page.to_f).ceil
	end
	
	def more_posts
		if current_user
			@timestamp = params[:timestamp]
			@posts = Post.find_by_sql(["SELECT workout_title, workout_type, workout_description, posts.video_url, posts.image, posts.thing_id, posts.user_id, 
			posts.created_at, posts.id, comment, name, email, image_path, rounds_and_reps, (SELECT SUM(total_points) FROM results WHERE results.post_id = posts.id) 
			AS total_points, (SELECT COUNT(*) FROM likes WHERE likes.thing_id = posts.thing_id) AS like_count, (SELECT COUNT(*) FROM comments WHERE comments.thing_id = posts.thing_id) 
			AS comment_count, workout_id, points_per_workout, seconds FROM posts JOIN workouts ON workouts.id = posts.workout_id JOIN users ON users.id = posts.user_id WHERE 
			posts.user_id = ? AND posts.created_at <= ? ORDER BY posts.created_at DESC OFFSET ? LIMIT 5", params[:id], Time.at(@timestamp.to_f), params[:offset]])
			@count = params[:count].to_i
			@new_off = params[:offset].to_i + 5
			respond_to do |format|
				format.html
				format.js
			end
		end
	end
	
	def internal_signup
		@user = current_user if (current_user && current_user.provider.present?)
	end
	
	def update_signup
		if (current_user && current_user.provider.present?)
			@user = current_user
			@letter = params[:user][:name][0,1].downcase
			@letter =~ /[a-z]/ ? @image_path = "letters/#{@letter}.svg" : @image_path = "default_avatar.svg"
			if @user.update_attributes(params.require(:user).permit(:name, :email, :password).merge(image_path: @image_path, provider: nil))
				flash[:notice] = "Account updated!"
				redirect_to "/settings"
			else
				flash[:alert] = "Error - " + @user.errors.full_messages[0]
				redirect_to "/internal-signup"
			end
		end
	end
	
	def get_emoji_form
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	def set_emoji
		if current_user
			@user = current_user
			if (1..12).include? params[:emoji][:emoji_value].to_i
				@emoji_val = params[:emoji][:emoji_value]
				@image_path = "emojis/emoji_#{params[:emoji][:emoji_value]}.svg"
			else
				@emoji_val = 1
				@image_path = "emojis/emoji_1.svg"
			end
			if @user.update_attributes(image_path: @image_path, emoji_value: @emoji_val)
				flash[:notice] = "Profile picture updated!"
				Avatar.where(user_id: @user.id).destroy_all
			else
				flash[:alert] = "Error - " + @user.errors.full_messages[0]
			end
		end
		redirect_to "/settings"
	end
	
	def new_account_recovery
	end
	
	def send_account_recovery
		@user = User.find_by_email(params[:account_recovery][:email].downcase) if params[:account_recovery][:email].present?
		if @user
			@token = rand(36**72).to_s(36)
			@password_token = PasswordToken.new(user_id: @user.id, password: @token)
			MainMailer.account_recovery(@user, @token, @password_token.id).deliver_now if @password_token.save
		end
		flash[:modal] = true
		redirect_to "/account-recovery"
	end
	
	def edit_account_recovery
		@t = PasswordToken.where(user_id: params[:id], id: params[:tid]).first
		@user = User.find(params[:id]) if (@t && @t.authenticate(params[:token]))
	end
	
	def update_account_recovery
		@t = PasswordToken.where(user_id: params[:id], id: params[:tid]).first
		if @t && @t.authenticate(params[:token])
			@user = User.find(params[:id])
			if @user && @user.update_attributes(password: params[:user][:password_new])
				PasswordToken.where(user_id: @user.id).destroy_all
				flash[:notice] = "Password reset successfully - log in with new password."
				MainMailer.password_reset_successful(@user).deliver_later
			else
				flash[:alert] = "Error - " + @user.errors.full_messages[0] if @user
			end
		end
		flash[:alert] = "Invalid or expired token." unless @user
		redirect_to "/login"
	end
	
	def validate_email
		@user = User.find_by_id(params[:id])
		if @user
			if @user.email_validated == true
				flash[:notice] = "You've already validated your email."
			else
				@email_token = EmailToken.where(user_id: params[:id], id: params[:tid]).first
				if @email_token && @email_token.authenticate(params[:token])
					if @user.update_attributes(email_validated: true)
						flash[:notice] = "Thank you for validating your email!"
						EmailToken.where(user_id: @user.id).destroy_all
					else
						flash[:alert] = "Error - " + @user.errors.full_messages[0]
					end
				else
					flash[:alert] = "You've used an invalid or expired token."
				end
			end
		end
		if current_user
			redirect_to "/settings"
		else
			redirect_to "/login"
		end
	end
	
	def resend_email
		if current_user
			@user = current_user
			if (@user.provider.present? == false && @user.email_validated == false)
				@token = rand(36**72).to_s(36)
				@email_token = EmailToken.create(user_id: @user.id, password: @token)
				MainMailer.welcome_with_verification(@user, @token, @email_token.id).deliver_now
				flash[:notice] = "Email sent!"
			end
		end
		redirect_to "/settings"
	end
	
	def get_badges
		@badges = EarnedBadge.joins("JOIN badges ON badges.id = earned_badges.badge_id").where(user_id: params[:user_id]).select(:badge_name, :badge_description, :image_path, :created_at).order(created_at: :desc)
		respond_to do |format|
			format.js
			format.html
		end
	end
	
	def get_user_friend_list
		@friend_list = get_friends(0, params[:user_id], 10)
		respond_to do |format|
			format.js
			format.html
		end
	end
	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :privacy_setting, :gender)
	end
	def password_params
		params.require(:user).permit(:password_new, :password_current).to_h
	end
end