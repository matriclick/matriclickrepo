class AdministrationController < ApplicationController
  before_filter :redirect_unless_admin
  # GET
  def index
  	@suppliers = Supplier.all
  end

	# GET
  #Muestra el perfil de la cuenta (Está redireccionada a supplier/main)
  def show_supplier_account
  	@supplier_account = SupplierAccount.find params[:id]
  end

	# GET
  #Muestra los productos de un proveedor (Está anidado a /suppliers/:id/supplier_account/products)
  def show_supplier_products
  	@supplier_account = SupplierAccount.find params[:id]
  	@products = @supplier_account.products
  end

	# GET
  #Muestra los servicios que ofrece un proveedor (Está anidado a /suppliers/:id/supplier_account/services)
  def show_supplier_services
  	@supplier_account = SupplierAccount.find params[:id]
  	@services = @supplier_account.services
  end

	# GET
  #Edita el perfil del proveedor (Está anidado a /suppliers/:id/supplier_account/edit)
  def edit_supplier_account
  	@supplier_account = SupplierAccount.find params[:supplier_account_id]
		@industry_categories = IndustryCategory.order "name"
    @industry_category_types = IndustryCategoryType.all
  end

	# GET
  #Edita los productos ofrecidos por el proveedor (Se muestran en el edit_supplier_account)
  def edit_supplier_product  
  	@product = Product.find params[:product_id]
  	@product.videos.build if @product.videos.blank?
	  @supplier_account = @product.supplier_account
	  @supplier = @product.supplier_account.supplier
		@product_types = ProductType.of_supplier @supplier
		@industry_categories = @supplier_account.industry_categories.where(:industry_category_type_id => 1) if @supplier_account.industry_categories.where(:industry_category_type_id => 1).count > 1
		@industry_cat_types = @industry_categories.inject({}) do |options, industry_category|
		  (options[industry_category.industry_category_type.name] ||= []) << [industry_category.name, industry_category.id]
  		options
		end
   # product_faqs = @product.product_faqs.build
  end

	# GET
  #Edita los servicios ofrecidos por el proveedor (Se muestran en el edit_supplier_account)

  def edit_supplier_service
  	@not_deliverable_services_ids = IndustryCategory.where(industry_category_type_id:2).map(&:id) 
  	@service = Service.find params[:service_id]
  	@service.videos.build if @service.videos.blank?
  	@supplier_account = @service.supplier_account
  	@supplier = @service.supplier_account.supplier
    @color_types = ColorType.all
		@industry_categories = @industry_categories = @supplier_account.industry_categories.where("industry_category_type_id = 3 OR industry_category_type_id = 2")
		#DZF here I make the dynamic grouped_options_for_select options
		@industry_cat_types = @industry_categories.inject({}) do |options, industry_category|
		  (options[industry_category.industry_category_type.name] ||= []) << [industry_category.name, industry_category.id]
  		options
		end
  end

	# PUT
  def update_supplier_account
  	@supplier_account = SupplierAccount.find params[:id]
  	
  	respond_to do |format|
  		if @supplier_account.update_attributes(params[:supplier_account], :validate => false)
  			format.html { redirect_to administration_show_supplier_account_path(@supplier_account) }
  		else
				@industry_categories = IndustryCategory.order "name"
		    @industry_category_types = IndustryCategoryType.all
  			format.html { render action: 'edit_supplier_account'}
  			format.json { render json: @supplier_account.errors, status: :unprocessable_entity }
  		end
  	end
  end
  
	# PUT
  def update_supplier_product
  	@product = Product.find params[:id]
  	
  	respond_to do |format|
  		if @product.update_attributes(params[:product])
  			format.html { redirect_to administration_show_supplier_products_path(@product.supplier_account)}
  		else
				@product = Product.find params[:id]
				@supplier_account = @product.supplier_account
				@supplier = @product.supplier_account.supplier
				@product_types = ProductType.of_supplier @supplier
				@industry_categories = @supplier_account.industry_categories.where(:industry_category_type_id => 1) if @supplier_account.industry_categories.where(:industry_category_type_id => 1).count > 1
  			format.html {render action: 'edit_supplier_product'}
  			format.json { render json: @product.errors, status: :unprocessable_entity }
  		end
  	end
  end

	# PUT
  def update_supplier_service
  	@service = Service.find params[:id]
  	
  	respond_to do |format|
  		if @service.update_attributes!(params[:service])
  			format.html { redirect_to administration_show_supplier_services_path(@service.supplier_account)}
  		else
				@service = Service.find params[:id]
				@supplier_account = @service.supplier_account
				@supplier = @service.supplier_account.supplier
				@color_types = ColorType.all
				@industry_categories = @supplier_account.industry_categories.where("industry_category_type_id = 3 OR industry_category_type_id = 2")
				#DZF here I make the dynamic grouped_options_for_select options
				@industry_cat_types = @industry_categories.inject({}) do |options, industry_category|
					(options[industry_category.industry_category_type.name] ||= []) << [industry_category.name, industry_category.id]
					options
				end
  			format.html {render action: 'edit_supplier_service'}
  			format.json { render json: @service.errors, status: :unprocessable_entity }
  		end
  	end
  end
  
	# DELETE
  def destroy_supplier
  	@supplier = Supplier.find params[:id]
  	@supplier.destroy
  	
  	respond_to do |format|
  			format.html { redirect_to action: 'index'}
  	end
  end
  
	# DELETE
  def destroy_supplier_product
  	@product = Product.find params[:id]
  	@supplier = Supplier.find(@product.supplier_account.supplier_id)
  	@product.destroy
  
  	respond_to do |format|
  			format.html { redirect_to administration_show_supplier_products_path(@supplier) }
  	end
  end
  
	# DELETE
  def destroy_supplier_service
  	@service = Service.find params[:id]
  	@supplier = Supplier.find(@service.supplier_account.supplier_id)
  	@service.destroy
  
  	respond_to do |format|
  			format.html { redirect_to administration_show_supplier_services_path(@supplier) }
  	end
  end
  
  # REVIEWS
  # GET
  def reviews
  	@supplier_accounts = SupplierAccount.all
  end
  
  # GET
  def new_review
  	@supplier_account = SupplierAccount.find params[:id]
  	@review = @supplier_account.reviews.new
  	@review.build_star_rating
  end
    
  # GET
  def edit_review
  	@review = Review.find params[:id]
  	@supplier_account = SupplierAccount.find params[:supplier_account_id]
  end
  
  # PUT
  def update_review
  	@review = Review.find params[:id]
  	
  	respond_to do |format|
  		if @review.update_attributes(params[:review])
  			format.html { redirect_to administration_reviews_path}
  		end	
  	end	
  end
  
  # DELETE
  def destroy_review
  	@review = Review.find params[:id]
  	
  	@review.destroy
  	respond_to do |format|
  		format.html {redirect_to administration_reviews_path}
  	end
  end
end
