class PostImage < ActiveRecord::Base
  belongs_to :post
  has_attached_file :photo, :styles => {
		:thumb => "100x100>",
		:smaller => "120x90>",
		:small => "200x150>",
		:tiny => "40x40>"
	}, :whiny => false
  
  validates_attachment_size :photo, :less_than => 2.megabytes
end
