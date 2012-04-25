class ReviewsController < ApplicationController
	before_filter :authenticate_user!

	# GET
	def index
		@user = current_user
		if @user.user_account.wedding_tentative_date.blank?
			@nothing_to_show = true
		else
			if @user.user_account.wedding_tentative_date < Date.today
				@supplier_accounts = SupplierAccount.user_reviewable(@user.user_account)	
				@review = Review.new
				@review.build_star_rating
			else
				@nothing_to_show = true
			end
		end
	end
	
	# POST
	#REMOTE
	def create
		@review = Review.new params[:review]
		@review.user_id = current_user.id unless current_user.role_id == 1 #DZF when user is administrator don't make any relationship
	
	  respond_to do |format|
	    if @review.save
		
				# FGM: Update user account so later notificacion email won't be sent.
				current_user.user_account.update_attribute(:did_review, true)
	      format.html { redirect_to :back }
	      format.js
	    else
				format.js
			end
	  end
	end
	
	def check_env
		unless Rails.env == "development"
			redirect_to root_path
		end
	end
end
