class PostBadgeJob < ApplicationJob
	queue_as :default
	def perform(user_id)
		@user_id = user_id
		@badge_count_hash = {1 => 1, 25 => 2, 50 => 3, 100 => 4, 200 => 5, 500 => 6} #First timer, First Quarter, Nifty Fifty, Turn of the Century, Bicentennial, Man!, Half-Millennial
		@post_count = Post.where(user_id: @user_id).count
		@user_data = User.find_by_sql(["SELECT (SELECT COUNT(*) FROM posts WHERE posts.user_id = ?) AS workout_count, 
		(SELECT SUM(posts.seconds) FROM posts WHERE posts.user_id = ?) AS total_seconds,
		(SELECT SUM(total_points) FROM posts JOIN results ON results.post_id = posts.id WHERE posts.user_id = ?) AS total_points FROM posts", @user_id, @user_id, @user_id]).first
		if @user_data
			BadgeCreationJob.perform_now(@user_id, @badge_count_hash[@user_data.workout_count]) if @badge_count_hash[@user_data.workout_count].present?
			@total_seconds = @user_data.total_seconds
			@total_points = @user_data.total_points
			#Time-based badges
			if @total_seconds >= 3600 && @total_seconds < 28800 #One Hour
				BadgeCreationJob.perform_now(@user_id, 7)
			elsif @total_seconds >= 28800 && @total_seconds < 86400 #One workday (8 hours)
				BadgeCreationJob.perform_now(@user_id, 8)
			elsif @total_seconds >= 86400 && @total_seconds < 259200 #One full day (24 hours)
				BadgeCreationJob.perform_now(@user_id, 9)
			elsif @total_seconds >= 259200 && @total_seconds < 604800 #Three days
				BadgeCreationJob.perform_now(@user_id, 10)
			elsif @total_seconds >= 604800 #Full week
				BadgeCreationJob.perform_now(@user_id, 11)
			end
			#Point-based badges
			if @total_points >= 1000 && @total_points < 5280
				BadgeCreationJob.perform_now(@user_id, 12)
			elsif @total_points >= 5280 && @total_points < 10000
				BadgeCreationJob.perform_now(@user_id, 13)
			elsif @total_points >= 5280 && @total_points < 10000
				BadgeCreationJob.perform_now(@user_id, 13)
			elsif @total_points >= 10000 && @total_points < 50000
				BadgeCreationJob.perform_now(@user_id, 14)
			elsif @total_points >= 50000
				BadgeCreationJob.perform_now(@user_id, 15)
			end
		end
	end
end