module Spree
  module Admin
    class DisluAlbumsController < BaseController

      def index
        @dislu_album = Spree::DisluAlbum.new
        @albums = Spree::DisluAlbum.all
      end
      def new
        @dislu_album = Spree::DisluAlbum.new
      end


      def show
        @dislu_album = Spree::DisluAlbum.find(params[:id])
      #  @products = @product_import.products
      end

      def create
        @dislu_album = Spree::DisluAlbum.create(album_params)
        img  = album_params[:img]
        if @dislu_album.save
           if img
             @dislu_album.img.attach(img)
           end
          #@dislu_album.img.attach(im g)

          flash[:notice] = Spree.t('new_album')

          redirect_to admin_dislu_albums_path
        end


        #ImportProductsJob.perform_later(@product_import)
        
      end

      

     

      private
        def album_params
          params.require(:dislu_album).permit!
        end
    end
  end
end
