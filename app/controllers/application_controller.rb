class ApplicationController < ActionController::Base  
  before_filter :set_user_language, :new_feedback, :load_navigation, :count_unread_conversations, :count_unread_bookings, :load_budget_slots
	protect_from_forgery

	rescue_from CanCan::AccessDenied do |exception|
	  redirect_to root_url, :alert => exception.message
  end
	
	# FGM: rate any object (rateable). Only one vote per object per user.
	# Only one vote per object per cookie stored.
	def rate
		@object = eval("#{params[:class]}.find(#{params[:id]})")
		@star_value = params[:star_value]
		@user = User.find params[:user_id] if params[:user_id]
		
		# FGM: If there's a user, check if voted object exists.
		if @user.present?
			if @object.voted_by_user?(@user)
				@star_rating = @object.star_ratings.where(user_id: @user.id).first
				@star_rating.update_attribute(:value, params[:star_value])
			else
				@object.star_ratings << StarRating.new(value: @star_value, user_id: @user.id)
			end		
			
		# FGM: If no user, store vote in cookies.
		# ALERT: Cookies can't store hashes, so a string is being stored for later parsing and evaluation.
		else
			if cookies[:rated].blank?
				
				# FGM: Storing cookie as "object_id@object_class"
				cookies[:rated] = "#{@object.id}@#{@object.class}"
				@object.star_ratings << StarRating.new(value: @star_value)
			else
				# FGM: Convert string to hash (i.e. "uu@p, xx@m, yy@n, zz@m" will output {"m" => ["xx", "zz"], "n" => ["yy"], "p" => ["uu"]})
				cookies[:rated].to_s.split(/,/).inject(Hash.new{ |h,k| h[k]=[] }) do |h,s|
					v,k = s.split(/@/)
					h[k] << v
					@hashed_cookie = h
				end
				unless @hashed_cookie[@object.class.to_s].include? @object.id.to_s
					cookies[:rated] += ",#{@object.id}@#{@object.class}"
					@object.star_ratings << StarRating.new(value: @star_value)
				end
			end
		end
		
		respond_to do |format|
			format.js
		end
	end
	
	# FGM: Permute ProductImage pair :image_indexes
	def set_image_index
		# FGM: Could have been "DRYer"...
		if params[:product_id]
		  @product = Product.find params[:product_id]
			@product_image = ProductImage.find params[:id]
	    @the_other_product_image = ProductImage.where(:product_id => @product.id, :image_index => params[:image_index]).first

	    # FGM: image_index exchange
	    # FGM: WARNING: update_attribute skips validation (:set_image_index_depending_on_active) intentionally.
	    @the_other_product_image.update_attribute :image_index, @product_image.image_index
	    @product_image.update_attribute :image_index, params[:image_index]
		elsif params[:service_id] and params[:room_id].blank?
			@service = Service.find params[:service_id]
			@service_image = ServiceImage.find params[:id]
	    @the_other_service_image = ServiceImage.where(:service_id => @service.id, :image_index => params[:image_index]).first

	    # FGM: image_index exchange
	    # FGM: WARNING: update_attribute skips validation (:set_image_index_depending_on_active) intentionally.
	    @the_other_service_image.update_attribute :image_index, @service_image.image_index
	    @service_image.update_attribute :image_index, params[:image_index]
		elsif params[:room_id]
			@room = Room.find params[:room_id]
			@room_image = RoomImage.find params[:id]
	    @the_other_room_image = RoomImage.where(:room_id => @room.id, :image_index => params[:image_index]).first

	    # FGM: image_index exchange
	    # FGM: WARNING: update_attribute skips validation (:set_image_index_depending_on_active) intentionally.
	    @the_other_room_image.update_attribute :image_index, @room_image.image_index
	    @room_image.update_attribute :image_index, params[:image_index]
		end
		
		respond_to do |format|
			format.html { redirect_to :back }
			format.js { render "load_images_for_edit" }
		end
	end
	
  # FGM: Update :active attribute.
  # FGM: Update Images with greater image_index when a given Image is deactivated.
	def toggle_active
		# FGM: Could have been "DRYer"...
		if params[:product_id]
			@product = Product.find params[:product_id]
			@product_image = ProductImage.find params[:id]
			if @product_image.active
			  @later_product_images = ProductImage.where("image_index > #{@product_image.image_index}").all
	      @later_product_images.each { |pi| pi.update_attribute :image_index, pi.image_index - 1  }
	      @product_image.update_attributes :active => false
	    else 
	      @product_image.update_attributes :active => true
	    end
		elsif params[:service_id] and params[:room_id].blank?
			@service = Service.find params[:service_id]
			@service_image = ServiceImage.find params[:id]
			if @service_image.active
			  @later_service_images = ServiceImage.where("image_index > #{@service_image.image_index}").all
	      @later_service_images.each { |pi| pi.update_attribute :image_index, pi.image_index - 1  }
	      @service_image.update_attributes :active => false
	    else 
	      @service_image.update_attributes :active => true
	    end
		elsif params[:room_id]
			@room = Room.find params[:room_id]
			@room_image = RoomImage.find params[:id]
			if @room_image.active
			  @later_room_images = RoomImage.where("image_index > #{@room_image.image_index}").all
	      @later_room_images.each { |ri| ri.update_attribute :image_index, ri.image_index - 1  }
	      @room_image.update_attributes :active => false
	    else 
	      @room_image.update_attributes :active => true
	    end
		end
		
		respond_to do |format|
			format.html { redirect_to :back }
			format.js {render "load_images_for_edit"}
		end
	end
	
	private	
	def set_supplier_layout
		@supplier_layout = true
	end
	
	def load_user_tools_menu
		@show_user_tools = true
	end

	def find_supplier
		@supplier = current_supplier
		redirect_if_supplier_account_invalid(@supplier)
	end
	
	def new_feedback
	  @feedback = Feedback.new
  end
  
  def load_reference
  	@reference_request = ReferenceRequest.new
 	end
	
	def redirect_if_supplier_account_invalid(supplier)
		if supplier.supplier_account.blank?
			supplier.ensure_supplier_account_exists
		end
		# FGM: Validation for rut was disabled... for the moment
		# if supplier.supplier_account.rut.blank?
		# 			# FGM: Redirection occurs unless user wants to update his data.
		# 			redirect_to edit_supplier_account_url(supplier) unless (params[:controller] == "supplier_accounts" and (params[:action] == "edit" or params[:action] == "update"))
		# 		end
	end
	
	def after_sign_in_path_for(resource)
		# FGM: Control that only a User or Supplier is logged in...
		if resource.kind_of? User
			sign_out(:supplier)
			if params[:campaign] == 'true'
				edit_user_profile_path(:campaign => true)
			else
				blog_path
			end
		elsif resource.kind_of? Supplier
			sign_out(:user)
			supplier_home_path
		else
			root_path
		end
	end
	
	def current_ability
		if user_signed_in?
			@current_ability ||= Ability.new(current_user)
		elsif supplier_signed_in?
			@current_ability ||= Ability.new(current_supplier)
		end
	end
	
  # This sets the default language for a single session
  def set_user_language
    I18n.locale = current_user.language if user_signed_in?
  end

  # DZF: This redirects to the preview page when session[:preview] is true
  def redirect_if_preview_exists
    @supplier = current_supplier
    if session[:preview]
      redirect_to products_catalog_supplier_description_url(@supplier, :preview => true )
    end
  end
  
	def load_budget_types
		@budget_types = BudgetType.all
  end
  
  def load_user_account
  	if user_signed_in?
	  	@user_account = current_user.user_account unless session[:preview] == true
	  end
  end

	def load_navigation
		if params[:industry_category_ids] and (id = params[:industry_category_ids]).kind_of? String
			@industry_category = IndustryCategory.find id unless params[:industry_category_ids] == 'all'
		end
	end

	def redirect_unless_user_signed_in #This works as before_filter :authenticate_user!
		unless user_signed_in? 
			redirect_to root_path	
		end
	end
	
	def count_unread_conversations
		if user_signed_in?
			@user_conversations_unread_count = 0
			unless current_user.blank?
				unless current_user.conversations.blank?
					@user_conversations_unread_count = current_user.conversations.joins(:messages).where("messages.user_read = 0 or messages.user_read is null").count
				end				
			end
		elsif supplier_signed_in?
			@supplier_conversations_unread_count = 0
			unless current_supplier.supplier_account.blank?
				unless current_supplier.supplier_account.conversations.blank?
					@supplier_conversations_unread_count = current_supplier.supplier_account.conversations.joins(:messages).where("messages.supplier_read = 0 or messages.supplier_read is null").count
				end
			end
		end
	end
	
	def count_unread_bookings
		if supplier_signed_in?
			unless current_supplier.supplier_account.events.blank?
				@supplier_no_confirmed_bookings = current_supplier.supplier_account.events.where(:booking_confirmed => false).count
			end
		end
	end
	
	def redirect_unless_admin
		if user_signed_in?
			redirect_to blog_url unless current_user.role_id == 1
		else
			redirect_to blog_url
		end
	end
  
  def authenticate_guest
		if !user_signed_in?
			
			# DZF creating and login_in an invitee user.
			u = User.new
			email = u.email ="invitado@"+Time.now.to_s.gsub(/(\s|\D)/, "")+".cl"
			u.role_id = 3
			u.skip_confirmation!
			u.save(:validate => false)
			
			# FGM: Transfer Demo account stuff to guest account
			@demo_account = User.find_by_email("demo@matriclick.com").user_account
      @demo_user = User.find_by_email("demo@matriclick.com")

      u.confirmation_token=@demo_user.confirmation_token
      u.confirmation_sent_at=@demo_user.confirmation_sent_at
      u.confirmed_at=@demo_user.confirmed_at
      u.save

      if @demo_account
				# FGM: Invitees
				@demo_account.invitees.each do |i|
					attrs = i.attributes
					attrs.delete("id")
					u.user_account.invitees << Invitee.new(attrs)
				end
				# FGM: Groom
				attrs = @demo_account.groom.attributes
				attrs.delete('id')
				attrs.delete('user_account_id')
				u.user_account.groom.update_attributes(attrs)
				# FGM: Bride
				attrs = @demo_account.bride.attributes
				attrs.delete('id')
				attrs.delete('user_account_id')
				u.user_account.bride.update_attributes(attrs)
				# # FGM: Budgets
				# @demo_account.budgets.each do |b|
				# 	attrs = b.attributes
				# 	attrs.delete "id"
				# 	u.user_account.budgets << Budget.new(attrs)
				# end
				# FGM: Expenses
				@demo_account.expenses.each do |e|
					attrs = e.attributes
					attrs.delete "id"
					u.user_account.expenses << Expense.new(attrs)
				end
				# FGM: Tentative Budget
				if @demo_account.tentative_budget.present?
					attrs = @demo_account.tentative_budget.attributes
					attrs.delete "id"
					u.user_account.tentative_budget = TentativeBudget.new(attrs)					
				end
				# FGM: Wedding tentative date
				u.user_account.update_attribute(:wedding_tentative_date, Date.today + 1.year)
			end

			sign_in(:user, User.find_by_email(email))
			# HH Why was this redirect_to here? (I commented it)
			# redirect_to blog_path
		end
  end

	def load_budget_slots
		if user_signed_in?
			if current_user.user_account.budget_slots.blank?
				current_user.user_account.update_attribute(:budget_distribution_type_id, BudgetDistributionType.where('name like "%Equitativo%"').first.id)
				IndustryCategory.all.each { |ic| current_user.user_account.budget_slots << BudgetSlot.create!(industry_category_id: ic.id, budget_distribution_type_id: BudgetDistributionType.where("name like '%Equitativo%'").first.id, budget_type_id: BudgetType.find_by_name("$$").id) }
			end
		end
	end

	def check_env
		unless Rails.env == "development"
			redirect_to root_path
		end
	end
end
