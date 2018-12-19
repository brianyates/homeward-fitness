class Post < ApplicationRecord
	mount_uploader :image, ImageUploader
	attr_accessor :minutes
	attr_accessor :delete_image
    validates :comment, length: { maximum: 251 }
	validates :seconds, presence: true
	validate :only_one_media, :at_least_one_result
	has_many :results
	accepts_nested_attributes_for :results
	after_validation :extract_video_id
	before_create :create_thing
	before_destroy :delete_thing
	after_create :badge_job
	
	def results_with_exercises
		Result.where(post_id: self.id).joins("JOIN exercises ON exercises.id = results.exercise_id").select(:points_per_rep, :reps_per_round, :reps, :exercise_description, :total_points, :exercise_id, :id).order(:exercise_id)
	end
	
	def comments(thing_id, timestamp, offset, limit = 5)
		Comment.joins("JOIN users ON users.id = comments.user_id").where("comments.thing_id = ? AND comments.created_at < ?", thing_id, Time.at(timestamp)).select("(SELECT COUNT(*) 
		FROM comment_likes WHERE comment_likes.comment_id = comments.id) AS like_count", :id, :user_id, :name, :image_path, :comment, :created_at).order(created_at: :desc).offset(offset).limit(limit)
	end
	
	private
	def extract_video_id
		if self.video_url.present?
			video_id = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/|vimeo\.com\/)([a-zA-Z0-9_-]{8,11})/.match(self.video_url)
			if video_id && video_id[1].present?
				provider = /(youtube|youtu\.be|vimeo)/.match(self.video_url)
				if provider[1] == "youtube" || provider[1] == "youtu.be"
					self.video_url = "https://www.youtube.com/embed/" + video_id[1]
				elsif provider[1] == "vimeo"
					v = self.video_url.split("/")
					self.video_url = "https://player.vimeo.com/video/" + v.last
				end
			else
				self.video_url = ""
			end
		end
	end
	def only_one_media
		if self.video_url.present?
			errors.add("Cannot attach", "more than one type of media") if self.image.present?
		elsif self.image.present?
			errors.add("Cannot attach", "more than one type of media") if self.video_url.present?
		end
	end
	def at_least_one_result
		self.results.each { |r| (@ok = true if (r.reps && r.reps > 0))}
		errors.add("Must complete at least one", "rep") unless @ok
	end
	def create_thing
		@thing = Thing.create(thing_type: 1)
		self.thing_id = @thing.id
	end
	def delete_thing
		Thing.find(self.thing_id).destroy
	end
	def badge_job
		PostBadgeJob.perform_later(self.user_id)
	end
end
