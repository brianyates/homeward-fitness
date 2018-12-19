class LeaderboardController < ApplicationController
	def index
		@ts = Time.now
		@ac = active_cutoff
		@result_count = result_count
		@top_performers = points_query(@ac, @ts, 0)
		@thing_id = ENV["LEADERBOARD_THING_ID"]
		@comment_count = Comment.where(thing_id: @thing_id).count
		@user_data = User.find_by_sql(["SELECT (SELECT SUM(posts.seconds) FROM posts WHERE posts.user_id = ? AND posts.created_at >= ?) AS total_seconds,
		(SELECT SUM(total_points) FROM posts JOIN results ON results.post_id = posts.id WHERE posts.user_id = ? AND posts.created_at >= ?) AS total_points FROM posts", current_user.id, @ac, current_user.id, @ac]).first if current_user
	end
	
	def load_top_performers
		@ts = Time.at(params[:timestamp].to_f)
		@ac = Time.at(params[:active_cutoff].to_f)
		@result_count = params[:result_count].to_i
		@top_performers = points_query(@ac, @ts, params[:offset])
		@new_off = params[:offset].to_i + 20
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	def load_top_performances
		@active_cutoff = active_cutoff
		@top_performances = ActiveWorkout.find_by_sql(["SELECT aw.id, aw.workout_id, w.workout_title, w.workout_type, rt.name, rt.seconds, rt.image_path, rt.points, rt.post_id, rt.user_id FROM active_workouts aw
		LEFT OUTER JOIN (SELECT posts.workout_id, posts.seconds, posts.id AS post_id, posts.user_id, users.name, users.image_path, (SELECT SUM(results.total_points) FROM results WHERE results.post_id = posts.id) AS points,
		row_number() OVER (PARTITION BY posts.workout_id ORDER BY (SELECT SUM(results.total_points) FROM results WHERE results.post_id = posts.id AND users.privacy_setting = 0) DESC, posts.seconds)
		FROM posts JOIN users ON users.id = posts.user_id AND posts.created_at >= ? AND users.privacy_setting = 0) rt ON rt.workout_id = aw.workout_id JOIN workouts w ON w.id = aw.workout_id 
		WHERE (rt.row_number = 1 OR rt.row_number IS NULL) ORDER BY id", @active_cutoff])
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	private
	def points_query(active_cutoff, timestamp, offset)
		Post.find_by_sql(["WITH p AS (SELECT SUM(total_points) AS points, user_id, name, image_path, RANK() OVER (ORDER BY sum(total_points) DESC) AS rank 
		FROM results JOIN posts ON posts.id = results.post_id JOIN users ON posts.user_id = users.id WHERE posts.created_at >= ? AND posts.created_at <= ? AND
		posts.active_workout = TRUE AND users.privacy_setting = 0 GROUP BY user_id, name, image_path ORDER BY points DESC), s AS (SELECT SUM(seconds) as seconds, user_id 
		FROM posts WHERE posts.created_at >= ? AND posts.created_at <= ? GROUP BY user_id) SELECT p.points, p.user_id, p.name, p.image_path, p.rank, s.seconds
		FROM p JOIN s ON s.user_id = p.user_id ORDER BY points DESC, seconds DESC LIMIT 20 OFFSET ?", active_cutoff, timestamp, active_cutoff, timestamp, offset])
	end
	def result_count
		User.find_by_sql(["SELECT COUNT(*) AS count_val FROM (SELECT user_id FROM users JOIN posts 
		ON posts.user_id = users.id WHERE posts.created_at >= ? AND posts.created_at <= ? AND users.privacy_setting = 0 GROUP BY user_id) AS u", @ac, @ts]).first.count_val.to_i
	end
end