class IndustryCategory < ActiveRecord::Base
	has_and_belongs_to_many :supplier_accounts
	has_many :product_types
	has_many :products
	has_many :services
	has_many :posts
  belongs_to :industry_category_type
	# Validations
	
  def self.by_products(ids)
    joins(:products).where("products.id in (?)",ids).group(:industry_category_id)
  end
  
  def self.by_services(ids)
    joins(:services).where("services.id in (?)",ids).group(:industry_category_id)
  end

	def products_and_services_count
		products.approved.count + services.approved.count
	end
end
