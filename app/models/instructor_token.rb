class InstructorToken < ApplicationRecord
	has_secure_password
	attr_accessor :email
	validates :user_id, presence: true
	validates :instructor_id, presence: true
end
