class DressImage < ActiveRecord::Base
	belongs_to :dress
	has_attached_file :dress, 
												:styles => {
													:big => "400x300>",
													:index => "160x120>",
	# 												:smaller => "120x90>",
	# 												:small => "200x150>",
													:tiny => "40x40>"
												}, :whiny => false
	
	validates_attachment_content_type :dress, :content_type => ['image/jpeg', 'image/png']
	validates_attachment_size :dress, :less_than => 2.megabytes
	
	# FGM: Get all the images and remove the cover
	def self.without_cover
		images = all
		images.slice!(0)
		images
	end	
end
