class CreateSpreeDisluAlbum < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_dislu_albums do |t|
    	t.string :name
    end
  end
end
