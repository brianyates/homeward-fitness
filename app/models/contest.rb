class Contest < ApplicationRecord
	attribute :start_date, :corrected_date
	attribute :end_date, :corrected_date
	validates :contest_title, presence: true, length: {maximum: 30}
	validates :start_date, presence: true
	validates :end_date, presence: true
	validate :date_validations, on: :create
	before_create :create_thing
	after_create :add_contestant
	
	private
	def add_contestant
		Contestant.create!(contest_id: self.id, user_id: self.owner_id, status: 2, inviter_id: self.owner_id)
	end
	def date_validations
		if self.start_date < Date.today
			errors.add("Start date", "cannot be in the past")
		elsif self.start_date > self.end_date
			errors.add("End date", "cannot be before start date")
		end
	end
	def create_thing
		@thing = Thing.create(thing_type: 3)
		self.thing_id = @thing.id
	end
		
end
