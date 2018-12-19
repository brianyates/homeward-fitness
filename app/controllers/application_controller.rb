class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	force_ssl unless Rails.env.development?
	helper_method :all_countries
	helper_method :all_states
	helper_method :current_user
	helper_method :is_admin?
	helper_method :active_cutoff
	helper_method :current_workouts
	helper_method :unread_alerts
	helper_method :friend_requests
	helper_method :thing_liked
	helper_method :comment_liked
	helper_method :reply_liked
	helper_method :contest_requests
	
	def thing_liked(thing_id)
		Like.where(user_id: current_user.id, thing_id: thing_id).select(:id).first if current_user
	end
	
	def comment_liked(comment_id)
		CommentLike.where(user_id: current_user.id, comment_id: comment_id).select(:id).first if current_user
	end
	
	def reply_liked(reply_id)
		ReplyLike.where(user_id: current_user.id, reply_id: reply_id).select(:id).first if current_user
	end
	
	def get_comments(thing_id, timestamp, offset)
		Comment.joins("JOIN users ON users.id = comments.user_id").where("comments.thing_id = ? AND comments.created_at < ?", thing_id, Time.at(timestamp)).select("(SELECT COUNT(*) FROM comment_likes WHERE comment_likes.comment_id = comments.id) AS like_count", :id, :user_id, :name, :image_path, :comment, :created_at).order(created_at: :desc).offset(offset).limit(5)
	end
	
	def unread_alerts
		Alert.where(user_id: current_user.id, read: false).count
	end
	
	def friend_requests
		Friend.where(user_id: current_user.id, status: 0).count
	end
	
	def contest_requests
		Contestant.where(user_id: current_user.id, status: 0).count
	end
  
  	def current_user 
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	
	def current_workouts
		Workout.find_by_sql("SELECT w.video_url, w.image, w.id AS id, s.instructor_name, w.instructor_id, s.website_url, w.duration, w.workout_title, w.workout_description, w.difficulty,
		w.required_equipment, a.updated_at, w.workout_type, w.point_cutoffs, w.points_per_workout, a.id AS active_id FROM active_workouts a 
		JOIN workouts w ON w.id = a.workout_id JOIN instructors s ON s.id = w.instructor_id ORDER BY a.id")
	end
	
	def is_admin?
		current_user.email == "byates123@gmail.com" if current_user
	end
	
	def workout_types
		{1 => "Time Limit - Completion Only", 2 => "Time Limit - As Many Rounds as Possible (AMRAP)", 3 => "No Time Limit - Record Time to Complete"}
	end
	
	def active_cutoff
		ActiveWorkout.last.updated_at
	end
	
	def get_friends(offset, id_value, limit = 30)
		Friend.joins("JOIN users ON users.id = friends.friend_id").select("users.name, (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id) AS workout_count,
		friends.user_id, users.image_path, friends.friend_id, (SELECT status FROM friends f WHERE f.user_id = #{current_user.id} AND f.friend_id = friends.friend_id) AS status, 
		(SELECT f.id FROM friends f WHERE f.user_id = #{current_user.id} AND f.friend_id = friends.friend_id) AS id").where(user_id: id_value, status: 2).order(:created_at).limit(limit).offset(offset)
	end

end
