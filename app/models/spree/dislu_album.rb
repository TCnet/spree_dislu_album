module Spree
  class DisluAlbum < Spree::Base
   

   has_many_attached :photos
   #has_many :photos, -> { order(:position) }, as: :viewable, dependent: :destroy, class_name: 'Spree::DisluImage'
  # has_many :photos, as: :viewable, dependent: :destroy, class_name: 'Spree::DisluImage'
    #has_one :photo, as: :viewable, dependent: :destroy, class_name: 'Spree::DisluImage'
  end
  
 end
