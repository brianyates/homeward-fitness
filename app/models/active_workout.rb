class ActiveWorkout < ApplicationRecord
	def exercises
		Exercise.where(workout_id: self.workout_id)
	end
end
