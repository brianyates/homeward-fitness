class LeaderboardNotificationJob < ApplicationJob
	queue_as :default
	#This job will alert users if they finished in the top three of the leaderboard
	def perform
		@active_cutoff = ActiveWorkout.last.updated_at
		@top_performers = Post.find_by_sql(["WITH p AS (SELECT SUM(total_points) AS points, user_id, name, image_path, email, RANK() OVER (ORDER BY sum(total_points) DESC) AS rank 
		FROM results JOIN posts ON posts.id = results.post_id JOIN users ON posts.user_id = users.id WHERE posts.created_at >= ? AND
		posts.active_workout = TRUE AND users.privacy_setting = 0 GROUP BY user_id, name, image_path, email ORDER BY points DESC), s AS (SELECT SUM(seconds) as seconds, user_id 
		FROM posts WHERE posts.created_at >= ? GROUP BY user_id) SELECT p.points, p.user_id, p.name, p.image_path, p.rank, s.seconds, p.email
		FROM p JOIN s ON s.user_id = p.user_id WHERE p.rank IN (1,2,3) ORDER BY p.rank", @active_cutoff, @active_cutoff])
		@top_performers.each do |r|
			@email_pref = User.joins("JOIN email_preferences ON users.id = email_preferences.user_id").where(id: r.user_id).select(:token_1, :token_2, :leaderboard, :email_validated).first
			BadgeCreationJob.perform_now(r.user_id, 19) if r.rank == 1 #leaderboard champ badge
			BadgeCreationJob.perform_now(r.user_id, 20) #podium placer badge
			MainMailer.leaderboard_podium(@top_performers, r, @email_pref).deliver_now if (@email_pref.leaderboard == 1 && @email_pref.email_validated == true)
		end
		@top_performances = ActiveWorkout.find_by_sql(["SELECT aw.id, aw.workout_id, w.workout_title, w.workout_type, rt.name, rt.email, rt.seconds, rt.image_path, rt.points, rt.post_id, rt.user_id FROM active_workouts aw
		LEFT OUTER JOIN (SELECT posts.workout_id, posts.seconds, posts.id AS post_id, posts.user_id, users.name, users.image_path, users.email, (SELECT SUM(results.total_points) FROM results WHERE results.post_id = posts.id) AS points,
		row_number() OVER (PARTITION BY posts.workout_id ORDER BY (SELECT SUM(results.total_points) FROM results WHERE results.post_id = posts.id AND users.privacy_setting = 0) DESC, posts.seconds)
		FROM posts JOIN users ON users.id = posts.user_id AND posts.created_at >= ? AND users.privacy_setting = 0) rt ON rt.workout_id = aw.workout_id JOIN workouts w ON w.id = aw.workout_id 
		WHERE (rt.row_number = 1 OR rt.row_number IS NULL) ORDER BY id", @active_cutoff])
		@top_performances.each do |r|
			if r.user_id.present? && r.workout_type !=1
				@ep = User.joins("JOIN email_preferences ON users.id = email_preferences.user_id").where(id: r.user_id).select(:token_1, :token_2, :leaderboard, :email_validated).first
				BadgeCreationJob.perform_now(r.user_id, 21)	#top performance badge
				MainMailer.top_performance(r, @ep).deliver_now if (@ep.leaderboard == 1 && @ep.email_validated == true)
			end
		end
		
	end
end
