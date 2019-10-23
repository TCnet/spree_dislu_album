module Spree
  class DisluAlbum < Spree::Base
   
   has_many_attached :photos

   belongs_to :user, class_name: Spree.user_class.name

  end
  
 end
