module Spree
  ProductsHelper.class_eval do
  	def product_bullet_point(product)
      product.bullet_point.tr("\n","|").split('|').map{|x| "<p>"+x+"</p>"}.join
      #description = product.bullet_point.split('/').map{|x| "<p>"+x+"</p>"}.join
     # description = product.bullet_point.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
    end

    def product_description(product)
      description = if Spree::Config[:show_raw_product_description]
                      product.description
                    else
                      str=product.description.to_s.gsub(/(<br>?)/m,'<p></p>')
                      str.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')

                     # product.description.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
                      
                    end
      description.blank? ? Spree.t(:product_has_no_description) : description
    end
  end
end