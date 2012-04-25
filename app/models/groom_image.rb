class GroomImage < ActiveRecord::Base
	belongs_to :groom
	has_attached_file :groom, :styles => {:normal => "120x120>"}, :whiny => false
	
	validates_attachment_content_type :groom, :content_type => ['image/jpeg', 'image/png']
	validates_attachment_size :groom, :less_than => 2.megabytes
end
