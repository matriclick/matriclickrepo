class Post < ActiveRecord::Base
  self.per_page = 8
  belongs_to :industry_category
  has_many :blog_comments
  has_many :post_images, :dependent => :destroy
  
  accepts_nested_attributes_for :post_images, :reject_if => proc { |a| a[:photo].blank? }, :allow_destroy => true
  
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :i18n]
  
  def self.by_industry_category(id, name = nil)
		if id
			joins(:industry_category).where("industry_categories.id = #{id}")
		elsif name
			joins(:industry_category).where("industry_categories.name = #{name}")
		else
			scoped
		end
	end
end
