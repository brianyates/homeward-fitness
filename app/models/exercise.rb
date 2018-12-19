class Exercise < ApplicationRecord
	belongs_to :workout, required: false
end
