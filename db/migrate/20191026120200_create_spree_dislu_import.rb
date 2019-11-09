class CreateSpreeDisluImport < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_dislu_imports do |t|
       t.timestamps
	   t.references :user
    end
  end
end
