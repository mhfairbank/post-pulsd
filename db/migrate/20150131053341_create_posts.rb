class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :venue_name
    	t.string :precis
    	t.integer :price
    	t.string :description
    	t.string :location
    	
      t.timestamps null: false
    end
  end
end
