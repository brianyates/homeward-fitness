class ContactsController < ApplicationController
	def new
		@contact = Contact.new
	end
	def create
		@uri = URI("https://www.google.com/recaptcha/api/siteverify?secret=#{ENV["RECAPTCHA_KEY"]}&response=#{params["g-recaptcha-response"]}")
		@response = Net::HTTP.get(@uri)
		if @response
			@output = JSON.parse(@response)
			if @output["success"] == true
				@contact = Contact.new(params.require(:contact).permit(:name, :email, :content, :category))
				if @contact.save
					flash[:modal] = true
					MainMailer.new_contact_us(@contact.name, @contact.email).deliver_later
				else
					flash[:alert] = "Error - " + @contact.errors.full_messages[0]
				end
			else
				flash[:alert] = "Error - You might be a robot..."
			end
		else
			flash[:alert] = "An error occurred; try again later."
		end
		redirect_to "/contact-us"
	end
	def index
		@contacts = Contact.all.order(:resolved, :created_at)
		@categories = {0 => "General inquiry", 1 => "Data issue or software bug", 2 => "I want to be a workout instructor", 3 => "Other"}
	end
	def resolve
		if is_admin?
			@contact = Contact.find(params[:id])
			if @contact.update_attributes(resolved: true)
				flash[:notice] = "Item resolved"
			else
				flash[:alert] = "Error: " + @contact.errors.full_messages[0]
			end
			redirect_to "/all-contacts"
		end
	end	
end