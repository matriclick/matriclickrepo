class BrideImage < ActiveRecord::Base
	belongs_to :bride
	has_attached_file :bride, :styles => {:normal => "120x120>"}, :whiny => false
	
	validates_attachment_content_type :bride, :content_type => ['image/jpeg', 'image/png']
	validates_attachment_size :bride, :less_than => 2.megabytes
end
