module Spree
  module Admin
    class DisluImportsController < ResourceController
      require 'roo'
      require 'open-uri'


      def index
      	@dislu_import = spree_current_user.dislu_imports.new
        @imports = spree_current_user.dislu_imports.all.order('created_at desc')
      end

      def new
      	@dislu_import = spree_current_user.dislu_imports.new
      end

      def importdata
        config = Spree::DisluAlbumSetting.new
        shipid = set_up_shipping_category
        child_tax= 'Products'
        parent_tax = 'All'
        tax_name='Womens'

      	@import  = spree_current_user.dislu_imports.find(params[:id])
      	if @import.datafile.attached?
          url = main_app.url_for(@import.datafile)
          xlsx = Roo::Spreadsheet.open(url)
          #xlsx = Roo::Excelx.new(main_app.url_for(@import.datafile))
          
          sheet =  xlsx.sheet(0)
          if xlsx.sheets.include?('Template')
            sheet = xlsx.sheet('Template')
          end
          #str = AlbumsService.get_title_of_template sheet,' '
        
          product_params = Hash.new do |h,k| h[k] =[] end
          var_params =Hash.new do |h,k| h[k] =[] end
          import_from_title = config.import_row_from_title
          import_from_parent = import_from_title + 1
          import_from_va = import_from_title + 2

          


          mapo = AlbumsService.get_column_mappings sheet.row(import_from_title)

          
          parentsku= ''
          bullet_point =''

          mapo.each do |key,value|
             ssvalue = sheet.row(import_from_parent)[value]
             property ={}
             shiping_weight =""
             waist_size = ''
            case key
            when 'item_sku'
              parentsku= ssvalue.to_s
            when 'sale_price'
              product_params[:price] = (ssvalue.to_s.empty?) ? "0" : ssvalue
            when 'item_name'
              product_params[:name] = ssvalue.to_s.strip
            when 'product_description'
              product_params[:description] = ssvalue
            when 'sale_from_date'
              product_params[:available_on] = ssvalue
            when 'item_type'
              child_tax = ssvalue.capitalize
            when 'feed_product_type'
              parent_tax = ssvalue.capitalize
            when 'department_name'
              tax_name = ssvalue.capitalize
            when 'bullet_point1','bullet_point2','bullet_point3','bullet_point4','bullet_point5','bullet_point6'
              bullet_point += ssvalue.to_s
              bullet_point += '|'

            when 'country_of_origin'
              unless ssvalue.nil? || ssvalue.empty?
                property[:property] ='Country of Origin'
                property[:value] = ssvalue
                product_params[:properties] << property
              end

            when 'brand_name'
              unless ssvalue.nil? || ssvalue.empty?
                property[:property] ='Brand'
                property[:value] = ssvalue
                product_params[:properties] << property
              end

            when 'fabric_type'
              unless ssvalue.nil? || ssvalue.empty?
                property[:property] ='Fabric Type'
                property[:value] = ssvalue
                product_params[:properties] << property
              end
            when 'theme'
              unless ssvalue.nil? || ssvalue.empty?
                property[:property] ='Theme'
                property[:value] = ssvalue
                product_params[:properties] << property
              end
            when 'material_type'
              unless ssvalue.nil? || ssvalue.empty?
                property[:property] ='Theme'
                property[:value] = ssvalue
                product_params[:properties] << property
              end
            when 'fit_type'
              unless ssvalue.nil? || ssvalue.empty?
                property[:property] ='Fit Type'
                property[:value] = ssvalue
                product_params[:properties] << property
              end


            when 'closure_type'
              unless ssvalue.nil? || ssvalue.empty?
                property[:property] ='Closure Type'
                property[:value] = ssvalue
                product_params[:properties] << property
              end


            
              
              
            else
            end

          end
          product_params[:available_on] = Date.today - 1.day if product_params[:available_on].nil?
          product_params[:shipping_category_id] =  shipid
          product_params[:sku] = parentsku
          product_params[:bullet_point]= bullet_point.chop
          product_params[:meta_title]=config.ama_title.sub("{0}",product_params[:name]).sub("{1}", tax_name.capitalize)
          product_params[:meta_description] = config.ama_description.sub("{0}",product_params[:name]).sub("{1}",child_tax.capitalize).sub("{2}",Spree::Store.first.url)
          

          

          #add va

          meta_keywords = ""
          
          (import_from_va..sheet.last_row).each do |f|
            vatemp = Hash.new do |h,k| h[k] =[] end
            vatimgs = Hash.new do |h,k| h[k] =[] end
            properties = Hash.new do |h,k| h[k] =[] end
            stocks =""

            strimgs=''
            mapo.each do |key,value|
              
              ss={}
              
              
              tempvalue = sheet.row(f)[value]
              case key
              when 'item_sku'
                vatemp[:sku]= tempvalue
              when 'standard_price'
                vatemp[:standard_price]= tempvalue
              when 'list_price'
                vatemp[:list_price]= tempvalue
              when 'sale_price'
                vatemp[:price]= tempvalue
              when 'main_image_url','other_image_url1','other_image_url2','other_image_url3','other_image_url4','other_image_url5','other_image_url7','other_image_url8'
                unless tempvalue.nil? || tempvalue.empty?
                  #vatimgs[:images] << tempvalue
                  strimgs += tempvalue
                  strimgs +=' '
                 
                end
              when 'quantity'
                 stocks += (tempvalue.to_s.empty?)? '0' : tempvalue.to_s
                 stocks +=','


                
              when 'generic_keywords'
                 meta_keywords += tempvalue
                 meta_keywords += ","
             
              when 'size_name'
                ss[:name] = child_tax + '-Size'
                ss[:value] = tempvalue
                vatemp[:options] << ss
              when 'color_name'
                ss[:name] ='Color'
                ss[:value] =tempvalue
                vatemp[:options] << ss
              

              else
              end
              vatemp[:images] = strimgs
              vatemp[:stocks] = stocks.chop
               
            end
           
           # dds= {name: "ddds"}

            var_params[:variants] << vatemp
            #var_params[:variants] << vatimgs

          end



    
         product_params[:meta_keywords] =AlbumsService.get_str_by_length(meta_keywords.chop,200)


         option_types_params = [child_tax + '-Size', 'Color']
          

         # parms= variants.delete(:variants) || []
         parms = var_params[:variants]
    

          options = { 
            variants_attrs: parms,
            options_attrs: option_types_params }
         
          sp = p parms

          #set taxnonmy

          
         # @product = Spree::Core::Importer::Product.new(nil, pro_ss,options).create
          #@product = Spree::Core::Importer::Product.new(nil, pro_ss,options).create
          @product = ImportService.new(nil, product_params,options).create
          
          set_product_tax tax_name,parent_tax,child_tax,@product
         







         

         
      		#flash[:notice] = Spree.t('dislu_importdata')
          flash[:notice]  = sp
      		redirect_to admin_dislu_imports_path

      	end
      end


      def create
      	@dislu_import = spree_current_user.dislu_imports.create(import_params)
         if @dislu_import.save
          @dislu_import.datafile.attach(import_params[:datafile])
           
             
          
          #@dislu_album.img.attach(im g)

          flash[:notice] = Spree.t('new_dislu_import')

          redirect_to admin_dislu_imports_path
        end
      end

      def destroy

      	@import  = spree_current_user.dislu_imports.find(params[:id])

      	begin
          # TODO: why is @product.destroy raising ActiveRecord::RecordNotDestroyed instead of failing with false result
          @import.datafile.purge_later
          if @import.destroy
            flash[:success] = Spree.t('notice_messages.dislu_import_deleted')
          else
            flash[:error] = Spree.t('notice_messages.dislu_import_not_deleted', error: @import.errors.full_messages.to_sentence)
          end
        rescue ActiveRecord::RecordNotDestroyed => e
          flash[:error] = Spree.t('notice_messages.dislu_import_not_deleted', error: e.message)
        end

        respond_with(@import) do |format|
          format.html { redirect_to admin_dislu_imports_path }
          format.js { render_js_for_destroy }
        end
      end

      


       private
        def import_params
          params.require(:dislu_import).permit!
        end

        def set_product_tax(tax_name,parent_tax,child_tax,product)
          #Spree::Taxon.where(name: "jeans").first
          # "mother" "child" 'gchild'
          
          taxonomy = Spree::Taxonomy.where(name: tax_name).first_or_create

          ptaxon = Spree::Taxon.where(name: parent_tax).first_or_initialize 
          ptaxon.parent = taxonomy.root
          ptaxon.taxonomy = taxonomy
          ptaxon.save!
          
         
          ctaxon = Spree::Taxon.where(name: child_tax).first_or_initialize 
          ctaxon.parent = ptaxon
          ctaxon.taxonomy = taxonomy
          ctaxon.save!
          
          
          unless product.taxons.include?(ctaxon)
              product.taxons << ctaxon
          end
          

        end

        def set_up_shipping_category
          shipping_category = "Shipping By China EUB"
          id = Spree::ShippingCategory.find_or_create_by(name: shipping_category).id
        end

        

        def variants_params(parms,variants_key)
          parms.delete(variants_key) || []

        end



    end
  end
end
