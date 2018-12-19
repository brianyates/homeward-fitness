class NewsfeedController < ApplicationController
	def index
		@timestamp = Time.now
		if current_user
			@posts = logged_in_results(@timestamp, 0)
			@count = logged_in_count(@timestamp)
		else
			@posts = not_logged_in_results(@timestamp, 0)
			@count = not_logged_in_count(@timestamp)
		end
		@timestamp = @timestamp.to_f
	end
	
	def more_posts
		@timestamp = params[:timestamp]
		@ts = Time.at(@timestamp.to_f)
		if current_user
			@posts = logged_in_results(@ts, params[:offset])
			@count = logged_in_count(@ts)
		else
			@posts = not_logged_in_results(@ts, params[:offset])
			@count = not_logged_in_count(@ts)
		end
		@new_off = params[:offset].to_i + 5
		respond_to do |format|
			format.html
			format.js
		end
	end
	
	private
	def logged_in_results(timestamp, offset) #shows public results and results of people who the user is friends with
		Post.find_by_sql(["SELECT workout_title, workout_type, workout_description, posts.video_url, posts.image, posts.thing_id, posts.user_id, posts.created_at, posts.id, comment, name, email, image_path, rounds_and_reps, 
		(SELECT SUM(total_points) FROM results WHERE results.post_id = posts.id) AS total_points, (SELECT COUNT(*) FROM likes WHERE likes.thing_id = posts.thing_id) AS like_count, (SELECT COUNT(*) FROM comments WHERE comments.thing_id = posts.thing_id) AS comment_count,
		workout_id, points_per_workout, seconds FROM posts JOIN workouts ON workouts.id = posts.workout_id JOIN users 
		ON users.id = posts.user_id WHERE posts.created_at <= ? AND (users.privacy_setting = 0 OR posts.user_id = ? OR (posts.user_id IN (SELECT friend_id FROM friends WHERE friends.user_id = ?) AND users.privacy_setting = 1)) 
		ORDER BY posts.created_at DESC OFFSET ? LIMIT 5", timestamp, current_user.id, current_user.id, offset])
	end
	def not_logged_in_results(timestamp, offset) #only shows public results
		Post.find_by_sql(["SELECT workout_title, workout_type, workout_description, posts.video_url, posts.image, posts.thing_id, posts.user_id, posts.created_at, posts.id, comment, name, email, image_path, rounds_and_reps, 
		(SELECT SUM(total_points) FROM results WHERE results.post_id = posts.id) AS total_points, (SELECT COUNT(*) FROM likes WHERE likes.thing_id = posts.thing_id) AS like_count, (SELECT COUNT(*) FROM comments WHERE comments.thing_id = posts.thing_id) AS comment_count,
		workout_id, points_per_workout, seconds FROM posts JOIN workouts ON workouts.id = posts.workout_id JOIN users 
		ON users.id = posts.user_id WHERE posts.created_at <= ? AND users.privacy_setting = 0 ORDER BY posts.created_at DESC OFFSET ? LIMIT 5", timestamp, offset])
	end
	def logged_in_count(timestamp)
		Post.joins("JOIN users ON users.id = posts.user_id").where("posts.created_at <= ? AND (users.privacy_setting = 0 OR posts.user_id = ? OR (posts.user_id IN (SELECT friend_id FROM friends WHERE friends.user_id = ?) AND users.privacy_setting = 1))", timestamp, current_user.id, current_user.id).count
	end
	def not_logged_in_count(timestamp)
		Post.joins("JOIN users ON users.id = posts.user_id").where("posts.created_at <= ? AND users.privacy_setting = 0", timestamp).count
	end
	
end