module Spree
  module Admin
    class DisluTemplatesController < ResourceController
      #include AlbumsHelper
      #require 'roo'
      #include Spree::Admin::TemplateSeed
      #include SpreeDisluAlbum::AlbumsCode
      #include SpreeDisluAlbum::SizeCode
      #include SpreeDisluAlbum::ColorCode
      #helper 'spree/admin/albums'
      #require 'spree_dislu_album/size_code'


      def create
        @dislu_template = spree_current_user.dislu_templates.create(template_params)
         if @dislu_template.save
         

          flash[:notice] = Spree.t('new_dislu_templates')

          redirect_to admin_dislu_templates_path
        end
      end
      
      def index
      	@dislu_template = spree_current_user.dislu_templates.new
        if(spree_current_user.dislu_templates.count<1)
          AlbumsService.get_template(spree_current_user)
        end
      	#@templates = Spree::DisluTemplate.all
        @templates = spree_current_user.dislu_templates.order('created_at desc')
        #SizeCode.size_map_for('xl')
        #size_map_for("xl")
        #SizeCode.size_map_for("xl")
        #Spree::Admin::AlbumsHelper.get_titlenumber 'ss'
        #AlbumsHelper::get_titlenumber
        #Spree::Admin::AlbumsHelper.DEFAULT_E
        #Spree::Dislu::TemplateSeed.DEFAULT_E
      end


      def edit
      	@dislu_template = spree_current_user.dislu_templates.find(params[:id])
      end

      def update
      	@template = spree_current_user.dislu_templates.find(params[:id])

      	if @template.update(template_params)
          
          flash[:success] = flash_message_for(@template, :successfully_updated)
          respond_with(@template) do |format|
            format.html { redirect_to location_after_save }
            format.js   { render layout: false }
          end
        end

      end

      def destory
      	@template = spree_current_user.dislu_templates.find(params[:id])
      	begin
          # TODO: why is @product.destroy raising ActiveRecord::RecordNotDestroyed instead of failing with false result
          if @template.destroy
            flash[:success] = Spree.t('notice_messages.dislu_template_deleted')
          else
            flash[:error] = Spree.t('notice_messages.template_not_deleted', error: @template.errors.full_messages.to_sentence)
          end
        rescue ActiveRecord::RecordNotDestroyed => e
          flash[:error] = Spree.t('notice_messages.template_not_deleted', error: e.message)
        end
        respond_with(@template) do |format|
          format.html { redirect_to admin_dislu_templates_url }
          format.js { render_js_for_destroy }
        end
      end


      private
        def template_params
          params.require(:dislu_template).permit!
        end




    end
  end
end
