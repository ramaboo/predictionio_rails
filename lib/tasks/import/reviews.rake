# The data file you downloaded.
REVIEW_DATA_FILE = Rails.root.join('data/yelp_training_set_review.json')

namespace :import do
  desc 'Import reviews from Yelp data!'
  task reviews: :environment do
    # Loop through each line of the data file.
    File.open(REVIEW_DATA_FILE, 'r').each_line do |line|

      # Decode JSON.
      object = ActiveSupport::JSON.decode(line)

      # Create a new review.
      review = Review.new

      # Assign values.
      review.yelp_business_id = object['business_id']
      review.yelp_user_id = object['user_id']
      review.stars = object['stars']
      review.content = object['text']
      review.created_at = object['date']

      # Save the review.
      review.save

      # Display progress in the console.
      puts "Imported review #{review.id} with #{review.stars} stars."
    end
  end

  desc 'Setup review relationships.'
  task setup_review_relationships: :environment do
    # Loop though the reviews table.
    Review.find_each do |review|
      # Find and set the user.
      review.user = User.where(yelp_user_id: review.yelp_user_id).first

      # Find and set the business.
      review.business = Business.where(yelp_business_id: review.yelp_business_id).first

      # Save the changes.
      review.save

      # Display progress in the console.
      puts "Setup relationship for review #{review.id}."
    end
  end
end