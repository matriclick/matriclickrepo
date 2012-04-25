class SupplierAccountsController < ApplicationController
	before_filter :authenticate_supplier!, :set_supplier_layout, :find_supplier
	load_and_authorize_resource
	
	def show
		@unread_bookings = true if @supplier.supplier_account.unread_bookings?
	end
	
  def edit
		@industry_categories = IndustryCategory.order "name"
    @industry_category_types = IndustryCategoryType.all
		@supplier_account = @supplier.supplier_account
  end

  def update
		@supplier_account = @supplier.supplier_account
	
	# FGM: Set language without updating supplier_account attributes
		if params[:set_language]
      @supplier.update_attributes :language => params[:set_language]
      I18n.locale = @supplier.language
			redirect_to :back
			
			# FGM: Break update method.
			return
    end
  # DZF: Set Supplier approvation to true when supplier click in the preview link_to  
    if params[:validate_account]
      @supplier_account.update_attribute :approved_by_supplier, true
      redirect_to :back
      return
    end

		@aux = @supplier_account.industry_category_ids
		#DZF this is saving even when a supplier don't have any industry_category
		@supplier_account.industry_category_ids = params[:supplier_account][:industry_category_ids] ||= []

		respond_to do |format|
			if @supplier_account.update_attributes params[:supplier_account]
        format.html { redirect_to supplier_home_path, :notice => "#{t('activerecord.successful.messages.updated', :model => @supplier_account.class.model_name.human)}" }
			else
			  @supplier_account = @supplier.supplier_account
        @industry_category_types = IndustryCategoryType.all
			  #saving back the industry_categories
			  @supplier_account.industry_category_ids = @aux
			  # Changed IndustryCategories to IndustryCategory DZF
				@industry_categories = IndustryCategory.order "name"
				format.html { render "edit" }
			end
		end
  end
  
  def calendar
		@no_more_booking = NoMoreBooking.new
		
		if params[:event_date]
			@date = params[:month] ? Date.parse(params[:month]) : Date.parse(params[:event_date])
		else
			@date = params[:month] ? Date.parse(params[:month]) : Date.today
		end
		
		if params[:read_booking_id]
			booking = Booking.find(params[:read_booking_id])
			booking.read_status :supplier => true
		end
		
    @supplier_account = @supplier.supplier_account
		@bookables = @supplier_account.bookables(:except => [:deleted_by_supplier, :related_confirmed, :destroyed, :custom])
    @bookings = @supplier_account.bookings.by_status(:except => [:deleted_by_supplier, :related_confirmed, :destroyed]).paginate(:page => params[:page], :per_page => 20)
    @important_dates = @supplier_account.important_dates
		@no_more_bookings = NoMoreBooking.where(:no_more_bookable_type => 'service', :no_more_bookable_id => @supplier_account.service_ids).all + NoMoreBooking.where(:no_more_bookable_type => 'product', :no_more_bookable_id => @supplier_account.product_ids).all
		# FGM: 'Custom bookings' are handled separatedly
		@custom_bookings = @supplier_account.bookings.by_status(:status => [:custom])

    respond_to do |format|
      format.html
    end
  end
  
	def new_booking
		@custom_booking = Booking.new
		
		respond_to do |format|
			format.html {render :layout => false}
		end
	end
	
	def create_booking
		@custom_booking = Booking.new params[:booking].merge(status: Booking::STATUS[:custom], read: Booking::READ_STATUS[:unread])
		if params[:bookable]
			@custom_booking.bookable_type = params[:bookable].split("_")[0]
			@custom_booking.bookable_id = params[:bookable].split("_")[1]
		end
		@custom_booking.save
		redirect_to :back
	end
	
	def set_bookings_lock
		@bookable_ids = params[:bookable_ids] || []
		
		unless @bookable_ids.blank?
			@bookable_ids.each do |class_name, ids|
				for id in ids
					NoMoreBooking.create!(:no_more_bookable_id => id, :no_more_bookable_type => class_name, :date => params[:date]) if NoMoreBooking.where(:no_more_bookable_id => id, :no_more_bookable_type => class_name, :date => params[:date]).first.blank?
				end
				if ids
					@delete = NoMoreBooking.where(:date => params[:date], :no_more_bookable_type => class_name) - NoMoreBooking.where(:date => params[:date], :no_more_bookable_id => ids, :no_more_bookable_type => class_name)
					@delete.each { |x| x.destroy }
				end
				if @bookable_ids.size == 1
					NoMoreBooking.where(:no_more_bookable_type => (class_name == 'Product' ? 'Service' : 'Product'), :date => params[:date]).destroy_all
				end
				
			end
		else
			NoMoreBooking.where(:date => params[:date]).destroy_all
		end
		
		respond_to do |format|
			format.html { redirect_to :back }
		end
	end
end