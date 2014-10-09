# The data file you downloaded.
USER_DATA_FILE = Rails.root.join('data/yelp_training_set_user.json')

namespace :import do
  desc 'Import users from Yelp data!'
  task users: :environment do
    # Loop through each line of the data file.
    File.open(USER_DATA_FILE, 'r').each_line do |line|

      # Decode JSON.
      object = ActiveSupport::JSON.decode(line)

      # Create a new user.
      user = User.new

      # Assign values.
      user.name = object['name']
      user.yelp_user_id = object['user_id']
      user.average_stars = object['average_stars']

      # Save the user.
      user.save

      # Display progress in the console.
      puts "Imported user #{user.id} with name #{user.name}."
    end
  end
end