class AdminController < ApplicationController
	def all_users
		if is_admin?
			@users = User.all
		end
	end
	
	def all_badges
		if is_admin?
			@badges = Badge.all.order(:id)
			@new_badge = Badge.new
		end
	end
	
	def create_badge
		if is_admin?
			@badge = Badge.new(params.require(:badge).permit(:badge_name, :badge_description, :image_path))
			if @badge.save
				flash[:notice] = "Badge created!"
			else
				flash[:alert] = "Error - " + @badge.errors.full_messages[0]
			end
			redirect_to "/all-badges"
		end
	end
	
	def edit_badge
		@badge = Badge.find(params[:id])
	end
	
	def update_badge
		if is_admin?
			@badge = Badge.find(params[:id])
			if @badge.update_attributes(params.require(:badge).permit(:id, :badge_name, :badge_description, :image_path))
				flash[:notice] = "Badge changes saved!"
			else
				flash[:alert] = "Error - " + @badge.errors.full_messages[0]
			end
			redirect_to "/all-badges"
		end
	end
	
	def destroy_badge
		@badge = Badge.find_by_id(params[:id])
		@badge.destroy if is_admin? && @badge
		flash[:notice] = "Badge deleted"
		redirect_to "/all-badges"
	end
end
