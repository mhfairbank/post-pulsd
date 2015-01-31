class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :venue
    	t.string :description
    	t.string :price
    	t.text :details
    	t.string :address
    	t.boolean :is_new, default: true

      t.timestamps null: false
    end
  end
end