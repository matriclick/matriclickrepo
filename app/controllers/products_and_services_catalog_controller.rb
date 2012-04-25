require 'will_paginate/array'
class ProductsAndServicesCatalogController < ApplicationController
  before_filter :new_feedback, :load_budget_types, :load_user_account, :load_reference
  before_filter :authenticate_user!, :only => [:conversations, :bookings, :add_booking]
  before_filter :authenticate_guest
  before_filter :redirect_if_guest, :only => [:conversations, :bookings]
  
  def select_industry_category
		@industry_categories = IndustryCategory.order "name"
	end
	
  def index
		@watch = params[:watch] || "suppliers"

		@objects = Product.search(params[:industry_category_ids]).alphabetized.approved.special_filter((current_user.user_account if user_signed_in? && !current_user.admin?))
		@objects += Service.search(params[:industry_category_ids]).alphabetized.approved.special_filter((current_user.user_account if user_signed_in? && !current_user.admin?))
		@objects_count = @objects.count
		@objects = @objects.paginate(:page => params[:page], :per_page => 12)

		
		@industry_categories = IndustryCategory.order "name"
		# FGM: SupplierAccounts SPECIAL FILTER (disabled pagination for Catalog)
		@supplier_accounts = SupplierAccount.by_industry_category(params[:industry_category_ids]).approved.special_filter((current_user.user_account if user_signed_in?)).sort_by {|sa| sa.reviews.size}.reverse
		
		# FGM: Stuff for Specialiazed blog
		# FGM: Fetch a single post when params provided
		@post = Post.find params[:post_id] if params[:post_id].present?
		# FGM: Fetch all posts for right positioned blog.
		@posts = Post.by_industry_category(params[:industry_category_ids]).order('created_at DESC')
		@industry_category = IndustryCategory.find params[:industry_category_ids]
		
		respond_to do |format|
			format.html # index.html.erb
			format.js
		end
  end
  
  def description
		if params[:preview]
      session[:preview] = true
    end

    @object = eval(params[:object_class]).find params[:id]
    @description = @object.description
    @supplier = @object.supplier_account.supplier
		@schedule = @object.schedule if @object.is_a? Service
  end

  def audio_and_video
  	@object = eval(params[:object_class]).find params[:id]
		@supplier = @object.supplier_account.supplier
  end

  def faqs
  	@object = eval(params[:object_class]).find params[:id]
  	if @object.class.to_s == "Product"
  		@faqs = @object.product_faqs
  	elsif @object.class.to_s == "Service"
			@faqs = @object.service_faqs
  	end
		@supplier = @object.supplier_account.supplier
  end
  
  def contacts
  	@object = eval(params[:object_class]).find params[:id]
  	@supplier = @object.supplier_account.supplier
  	@supplier_contacts = @object.supplier_account.supplier_contacts
  end
  
  def conversations
  	@object = eval(params[:object_class]).find params[:id]
  	@supplier = @object.supplier_account.supplier
  	@conversation = @object.conversations.by_user(current_user).first
 		if @conversation.blank?
 			@is_new = true
 			@conversation = Conversation.new
 			@message = @conversation.messages.build
 		else
 			@is_new = false
 			@message = Message.new
 			@conversation.messages.each do |message|
 				message.update_attributes(:user_read => true)
 			end
 		end
  end

	# GET
  def add_to_budget
  	@object = eval(params[:object_class]).find params[:id]
	  if user_signed_in?
	  	@object.add_to_budget(params[:budget_price], params[:budget_type_id], current_user.user_account)
		end
	  respond_to do |format|
	  	format.html {redirect_to :back}
	  end
  end
  
  def schedule_day
  	@object = Service.find params[:id]
		@supplier = @object.supplier_account.supplier
		@schedule = @object.schedule  	
  end
  
	def bookings
		@object = eval("#{params[:object_class]}.find(#{params[:id]})")
		
		# FGM: Update read status
		
		@supplier = @object.supplier_account.supplier
		@bookings = current_user.user_account.bookings.by_status(:except => [:deleted_by_supplier, :deleted_by_user, :destroyed, :related_confirmed]).where(bookable_type: @object.class, bookable_id: @object.id)

		# FGM: Check whether there's a confirmed booking for this 'bookable'
		@already_confirmed = @bookings.where(status: Booking::STATUS[:confirmed]).first.present?

		@important_dates = @supplier.supplier_account.important_dates
		@no_more_bookings = @object.no_more_bookings
		
		# Calendar Date
		if params[:calendar_search]
			@date = params[:month] ? Date.parse(params[:month]) : (Date.parse(params[:calendar_search]))
		elsif params[:booking_date]
			@date = params[:month] ? Date.parse(params[:month]) : (Date.parse(params[:booking_date]))
		else
			@date = params[:month] ? Date.parse(params[:month]) : (current_user.user_account.wedding_tentative_date.blank? ? Date.today : current_user.user_account.wedding_tentative_date)
		end
	end
  
	# POST
	def add_booking  	
		@booking = Booking.new(params[:booking].merge({status: Booking::STATUS[:pending], read: Booking::READ_STATUS[:unread]}))

	  respond_to do |format|
	  	if current_user.user_account.bookings << @booking
	  		format.html {redirect_to :back}
	  	else
        format.html {redirect_to :back}
        format.xml  { render :xml => @booking.errors, :status => :unprocessable_entity }
	  	end 	
	  end
  end
  
  # DELETE
  def destroy_booking
   	@booking = Booking.find params[:id]
		@booking.destroy
    
	  respond_to do |format|
	  	format.html {redirect_to :back}
	  	format.json { head :ok }
	  end
  end
  
  def download_file
  	@attached_file = AttachedFile.find params[:attached_file]
  	send_file @attached_file.attached.path, :type => @attached_file.attached_content_type, :filename => @attached_file.attached_file_name

  end
  
  def redirect_if_guest
  	if current_user.role_id == 3
  		if params[:action] == "bookings"
  			redirect_to :action => :description, :object_class => "Service"
  		else
  			@object = eval(params[:object_class]).find params[:id]
  			redirect_to :action => :description, :object_class => @object.class
  		end  		
  	end
  end
end
