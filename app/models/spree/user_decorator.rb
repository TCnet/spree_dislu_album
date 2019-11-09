module Spree::UserDecorator
  def self.prepended(base)
    base.has_many :dislu_albums, class_name: 'Spree::DisluAlbum'
    base.has_many :dislu_imports, class_name: 'Spree::DisluImport'
    base.has_many :dislu_templates, class_name: 'Spree::DisluTemplate'
  end
end

Spree::User.prepend Spree::UserDecorator