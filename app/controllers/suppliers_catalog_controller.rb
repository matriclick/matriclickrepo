class SuppliersCatalogController < ApplicationController
	before_filter :new_feedback, :load_budget_types, :load_user_account, :load_reference
	
  def supplier_description
    if params[:public_url] #DZF When is writted a supplierAccount.public_url int the URL, here we found the Supplier of that SupplierAccount
    	unless SupplierAccount.where(:public_url => params[:public_url]).first.blank?
    		@supplier = Supplier.find(SupplierAccount.where(:public_url => params[:public_url]).first.supplier_id)
    	end
    end
 
    if params[:id]
			@supplier = Supplier.find params[:id]
		end
		
		if @supplier.nil?
			respond_to do |format|
				format.html {redirect_to "/" }
			end
		else
			@presentation = @supplier.supplier_account.presentation
		end
  end
  
  def supplier_products_and_services
		if params[:preview]
      session[:preview] = true
    end		
  	@supplier = Supplier.find params[:id]
		# FGM: Increase Page Views counter
		@supplier.supplier_account.add_supplier_page_view(request.ip)
  	@products = @supplier.supplier_account.products
		@services = @supplier.supplier_account.services
		@presentation = @supplier.supplier_account.presentation
		# FGM: TODO: Not used? check when enable reviews
		if Rails.env == "development"
			#star rating
			@reviews = @supplier.supplier_account.reviews
			unless @reviews.count == 0
				@star_rating = 0
				@reviews.each do |rev|
					@star_rating += rev.star_rating.value
				end
				@star_rating = @star_rating / @reviews.count
				#review content
				@review_content = @supplier.supplier_account.reviews.order('rand()').first.content
			end
		end
  end

	def supplier_contacts
		@supplier = Supplier.find params[:id]
		@supplier_contacts = @supplier.supplier_account.supplier_contacts
		@presentation = @supplier.supplier_account.presentation
		if Rails.env == "development"
			#star rating
			@reviews = @supplier.supplier_account.reviews
			unless @reviews.count == 0
				@star_rating = 0
				@reviews.each do |rev|
					@star_rating += rev.star_rating.value
				end
				@star_rating = @star_rating / @reviews.count
				#review content
				@review_content = @supplier.supplier_account.reviews.order('rand()').first.content
			end
		end	
	end
	
	def supplier_reviews
		@supplier = Supplier.find params[:id]
		@presentation = @supplier.supplier_account.presentation
		#star rating
		@reviews = @supplier.supplier_account.reviews
		unless @reviews.blank?
			@average_star_rating = 0
			@reviews.each do |rev|
				@average_star_rating += rev.star_rating.value
			end
			@average_star_rating = @average_star_rating / @reviews.count
			#review content
			@review_content = @supplier.supplier_account.reviews.order('rand()').first.content
		end
	end
end
