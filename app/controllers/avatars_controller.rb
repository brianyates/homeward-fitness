class AvatarsController < ApplicationController
	def change_user
		if current_user
			@avatar = Avatar.new(params.require(:avatar).permit(:image).merge(user_id: current_user.id, avatar_type: 0))
			if @avatar.save
				flash[:modal] = true
			else
				flash[:alert] = @avatar.errors.full_messages[0]
			end
		end
		redirect_to "/settings"
	end
	def change_instructor
		if current_user && current_user.instructor_id.present?
			@avatar = Avatar.new(params.require(:avatar).permit(:image).merge(instructor_id: current_user.instructor_id, avatar_type: 1))
			if @avatar.save
				flash[:modal] = true
			else
				flash[:alert] = @avatar.errors.full_messages[0]
			end
		end
		redirect_to "/instructors/#{current_user.instructor_id}/owner"
	end
	def crop_user
		@avatar = Avatar.where(id: params[:id], user_id: current_user.id).first if current_user
		if @avatar && @avatar.update_attributes(params.require(:avatar).permit(:crop_x, :crop_y, :crop_w, :crop_h))
			flash[:notice] = "Profile picture updated!"
		else
			flash[:alert] = "Something went wrong...try again later."
		end
		redirect_to "/settings"
	end
	def crop_instructor
		@avatar = Avatar.where(id: params[:id], instructor_id: current_user.instructor_id).first if (current_user && current_user.instructor_id.present?)
		if @avatar && @avatar.update_attributes(params.require(:avatar).permit(:crop_x, :crop_y, :crop_w, :crop_h))
			flash[:notice] = "Profile picture updated!"
		else
			flash[:alert] = "Something went wrong...try again later."
		end
		redirect_to "/instructors/#{current_user.instructor_id}/owner"
	end
	def cancel_user
		@avatar = Avatar.where(id: params[:id], user_id: current_user.id).first if current_user
		@avatar.destroy! if @avatar
		respond_to do |format|
			format.js
			format.html
		end
	end
	def cancel_instructor
		@avatar = Avatar.where(id: params[:id], instructor_id: current_user.instructor_id).first if (current_user && current_user.instructor_id.present?)
		@avatar.destroy! if @avatar
		respond_to do |format|
			format.js
			format.html
		end
	end
end