class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :yelp_user_id
      t.string :name
      t.float :average_stars

      t.timestamps
    end
  end
end
