module Spree::UserDecorator
  def self.prepended(base)
    base.has_many :dislu_albums, class_name: 'Spree::DisluAlbum'
    
  end
end

Spree::User.prepend Spree::UserDecorator