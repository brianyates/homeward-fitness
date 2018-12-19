class Instructor < ApplicationRecord
	geocoded_by :address
	after_validation :geocode
	before_create :add_image
	validates :instructor_name, presence: true
	validates_format_of :website_url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
	
	def add_image
		letter = self.instructor_name[0,1].downcase
		letter =~ /[a-z]/ ? (self.image_path = "letters/#{letter}.svg") : (self.image_path = "letters/h.svg")
	end
end
