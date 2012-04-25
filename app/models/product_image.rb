class ProductImage < ActiveRecord::Base
	belongs_to :product
	has_attached_file :image, 
											:styles => {
												:thumb => "100x100>",
												:smaller => "120x90>",
												:small => "200x150>",
												:tiny => "40x40>"
											}, :whiny => false
	before_validation :set_image_index_depending_on_active
	before_destroy :set_image_index_after_destroy
	validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
	validates_attachment_size :image, :less_than => 2.megabytes

	def self.cover_first
		order("image_index")
	end
	
	# FGM: Get all the images and remove the cover
	def self.without_cover
		images = cover_first
		images.slice!(0)
		images
	end

  def self.active
    where(:active => true)
  end

  def self.inactive
    where(:active => false)
  end
	
  private
  # FGM: Will set image_index for new ProductImage based on existing ones (other ProductImages for the same Product).
  def set_image_index_depending_on_active
    unless product.nil?
      if self.active && self.image_index.nil?
        self.product.product_images.active.blank? ? self.image_index = 1 : self.image_index = self.product.product_images.active.count + 1
      elsif !self.active
        self.image_index = nil
      end
    end
  end
  
  def set_image_index_after_destroy
		ProductImage.all.each do |pi|
			if pi.image_index>self.image_index
				pi.update_attributes(:image_index => pi.image_index-1)
			end
		end
	end
end
