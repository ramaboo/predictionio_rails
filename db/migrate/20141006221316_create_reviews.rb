class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :yelp_business_id
      t.string :yelp_user_id
      t.float :stars
      t.text :content
      t.integer :user_id
      t.integer :business_id

      t.timestamps
    end
  end
end
