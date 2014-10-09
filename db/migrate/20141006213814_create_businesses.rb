class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :yelp_business_id
      t.string :name
      t.string :full_address
      t.string :city
      t.string :state
      t.float :stars

      t.timestamps
    end
  end
end
