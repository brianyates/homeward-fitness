class Result < ApplicationRecord
	attr_accessor :has_points
	belongs_to :post, required: false
	before_save :add_points
	
	private
	def add_points
		unless self.has_points
			@points = Exercise.where(id: self.exercise_id).select(:points_per_rep).first.points_per_rep
			self.total_points = @points * self.reps if (@points && self.reps)
		end
	end
end
