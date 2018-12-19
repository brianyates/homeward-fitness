class Contact < ApplicationRecord
	validates :email, presence: true
	validates :name, presence: true
	validates :content, presence: true
	validates :category, presence: true
end
