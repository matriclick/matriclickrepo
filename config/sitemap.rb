# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.matriclick.com"

SitemapGenerator::Sitemap.create do

  add '/blog', :priority => 0.7, :changefreq => 'daily'
  
  add '/products_and_services_catalog', :priority => 0.9, :changefreq => 'daily'
  
  add '/campaign/anecdotes', :changefreq => 'daily'
  
  add '/campaign/wedding_of_the_year', :priority => 0.7
  
  add '/campaign/how_to_win'
  
  add '/ceremonies/menu'
  
  add '/home/company'
  
  add '/campaign/give_it_away'
  
  add '/campaign/bases'
  
  add '/home/tour'
  
  add '/campaign/supplier_gallery'
  
  add '/dresses', :priority => 0.8
  
  add '/matrichecklist', :priority => 0.7
  
  Post.find_each do |post|
    add post_path(post), :lastmod => post.updated_at, :priority => 0.6
  end
  
  SupplierAccount.approved.each do |supplier_account|
    add supplier_products_and_services_path(supplier_account.supplier_id, :public_url => supplier_account.public_url), :lastmod => supplier_account.updated_at
  end
  
  Product.approved.each do |element|
    add products_and_services_catalog_description_path(element.id, :object_class => element.class), :lastmod => element.updated_at
  end
  
  Service.approved.each do |element|
    add products_and_services_catalog_description_path(element.id, :object_class => element.class), :lastmod => element.updated_at
  end
end
