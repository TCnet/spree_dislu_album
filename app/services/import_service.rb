class ImportService
        attr_reader :product, :product_attrs, :variants_attrs, :options_attrs
        require 'open-uri'

        def initialize(product, product_params, options = {})
          @product = product || Spree::Product.new(product_params)

          @product_attrs = product_params.to_h
          @variants_attrs = (options[:variants_attrs] || []).map(&:to_h)
          @options_attrs = options[:options_attrs] || []
        end

        def create
          if product.save
            variants_attrs.each do |variant_attribute|
              # make sure the product is assigned before the options=
              vatemp = variant_attribute
              #get image url string and delete form variant_attribute
              imagesurl=variant_attribute.delete(:images)
              stocks = variant_attribute.delete(:stocks)
              va = product.variants.create({ product: product }.merge(variant_attribute))
              set_stock stocks,va

              #set img
              unless imagesurl.nil? || imagesurl.empty?
                #create variants images for each variant
                imagesurl.split.each do |f|
                  unless f.empty?
                    fname = File.basename(f)
                    file = URI.parse(f).open 
                    vimage = va.images.new
                    vimage.attachment = { io: file,filename: fname }
                    vimage.save!
                  end
                end
              end
              #end set img
              #set stock


            end
            set_up_options 
          end
          product
        end

        def update
          if product.update(product_attrs)
            variants_attrs.each do |variant_attribute|
              # update the variant if the id is present in the payload
              if variant_attribute['id'].present?
                product.variants.find(variant_attribute['id'].to_i).update(variant_attribute)
              else
                # make sure the product is assigned before the options=
                product.variants.create({ product: product }.merge(variant_attribute))
              end
            end

            set_up_options 
          end

          product
        end

        private

        def set_stock(stocks,variant)
          stocks.split(',').each do |f|
            variant.stock_items.update(count_on_hand: f.to_i)
          end
        end

        def set_up_options
          options_attrs.each do |name|
            option_type = Spree::OptionType.where(name: name).first_or_initialize do |option_type|
              option_type.presentation = name
              option_type.save!
            end

            if name.include?('Size')&&(option_type.presentation!="Size")
              option_type.presentation = 'Size'
              option_type.save!
            end


            unless product.option_types.include?(option_type)
              product.option_types << option_type
            end
          end
        end

        
      end