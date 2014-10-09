class AddCounterCacheToUsers < ActiveRecord::Migration
  def up
    add_column :users, :reviews_count, :integer, null: false, default: 0

    User.find_each do |user|
      User.reset_counters(user.id, :reviews)
      puts "Updating count for #{user.id}."
    end
  end

  def down
    remove_column :users, :reviews_count
  end
end
