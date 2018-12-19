class Workout < ApplicationRecord
	mount_uploader :image, ImageUploader
	has_many :exercises, :dependent => :destroy
	accepts_nested_attributes_for :exercises, reject_if: proc { |attr| (attr['exercise_description'].blank?) }
	validates :workout_title, presence: true
	validates :workout_description, presence: true
	validates :video_url, presence: true
	validates :difficulty, presence: true
	validates :instructor_id, presence: true
	validates :required_equipment, presence: true 
	validates :workout_type, presence: true
	validate :must_have_exercise, :must_have_duration, :check_point_cutoffs, :check_points, :check_exercises
	before_create :create_thing
	before_destroy :delete_thing
	
	private
	def check_exercises
		self.exercises.each do |ex|
			errors.add("Exercise", "cannot be plural") if ex.exercise_description[-1].downcase == "s"
		end
	end
	
	def must_have_exercise
		errors.add("Workout","must have at least one exercise") if self.exercises.length < 1
	end
	def must_have_duration
		if self.workout_type == 3
			errors.add("Workout","cannot have a duration for this type") if self.duration.present?
		else
			errors.add("Workout","must have a duration for this type") unless self.duration.present?
		end
	end
	def check_points
		errors.add("Workout","must have points per workout for this type") if (self.workout_type == 1 && !self.points_per_workout.present?)
	end
	def check_point_cutoffs
		if self.workout_type == 3
			if self.point_cutoffs.present?
				@c = self.point_cutoffs.split(":")
				@t = @c[0].split(",")
				@p = @c[1].split(",")
				errors.add("Point cutoffs", "must have one more set of points than cutoffs") if (@t.length + 1) != @p.length
				@t.each_with_index do |t, i|
					if i > 0
						errors.add("Time cutoffs", "must be in ascending order") if (@t[i].to_i < @t[i-1].to_i)
						errors.add("Time cutoffs", "must be minute values") if (t.to_i % 60 != 0)
					end
				end
				@p.each_with_index do |p, i|
					if i > 0
						errors.add("Point values", "must be in descending order") if (@p[i].to_i > @p[i-1].to_i)
					end
				end
			else
				errors.add("Workout", "must have point cutoffs for this type")
			end
		elsif self.workout_type==2
			self.exercises.each do |ex|
				@round_total = ex.points_per_rep if ex.exercise_description.downcase == "round"
			end
			if @round_total
				sum = 0
				self.exercises.each do |ex|
					sum += (ex.points_per_rep * ex.reps_per_round) unless ex.exercise_description.downcase == "round"
				end
				errors.add("Total round points", "must equal sum of points * reps per round") unless (sum == @round_total)
			end
		end
	end
	def create_thing
		@thing = Thing.create(thing_type: 2)
		self.thing_id = @thing.id
	end
	def delete_thing
		Thing.find(self.thing_id).destroy
	end
		 
end
