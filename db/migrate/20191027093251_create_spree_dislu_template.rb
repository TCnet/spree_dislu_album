class CreateSpreeDisluTemplate < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_dislu_templates do |t|
      t.string  :name
      t.text    :title      
      t.timestamps
	  t.references :user
    end
  end
end
