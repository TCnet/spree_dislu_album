module Spree
  module Admin
    class DisluAlbumsController < ResourceController

      #include SpreeDisluAlbum::SizeCode



      def index
        @dislu_album = Spree::DisluAlbum.new
        @albums = Spree::DisluAlbum.all
        #size_map_for("xl")
      end
      def new
        @dislu_album = Spree::DisluAlbum.new
      end


      def show
        @dislu_album = Spree::DisluAlbum.find(params[:id])
      #  @products = @product_import.products
      end

      def edit
        @dislu_album =Spree::DisluAlbum.find(params[:id])
      end

      def update
       # @dislu_album = Spree::DisluAlbum.update(album_params)
      end


      def create
        @dislu_album = Spree::DisluAlbum.create(album_params)
        
        
        if @dislu_album.save
          @dislu_album.photos.attach(album_params[:photos])
           
             
          
          #@dislu_album.img.attach(im g)

          flash[:notice] = Spree.t('new_album')

          redirect_to admin_dislu_albums_path
        end


        #ImportProductsJob.perform_later(@product_import)
        
      end

      def destroy

        @album  = Spree::DisluAlbum.find(params[:id])

        begin
          # TODO: why is @product.destroy raising ActiveRecord::RecordNotDestroyed instead of failing with false result
          @album.photos.purge_later
          if @album.destroy
            flash[:success] = Spree.t('notice_messages.dislu_album_deleted')
          else
            flash[:error] = Spree.t('notice_messages.dislu_album_not_deleted', error: @import.errors.full_messages.to_sentence)
          end
        rescue ActiveRecord::RecordNotDestroyed => e
          flash[:error] = Spree.t('notice_messages.dislu_album_not_deleted', error: e.message)
        end

        respond_with(@album) do |format|
          format.html { redirect_to admin_dislu_albums_path }
          format.js { render_js_for_destroy }
        end
      end



     

      private
        def album_params
          params.require(:dislu_album).permit!
        end
    end
  end
end
