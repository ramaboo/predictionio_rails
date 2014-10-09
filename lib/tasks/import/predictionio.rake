# The value of `appId` in $POI_HOME/io.prediction.engines.itemrec/params/datasource.json.
PIO_APP_ID = 1
namespace :import do
  desc 'Send the data to PredictionIO'
  task predictionio: :environment do
    client = PredictionIO::EventClient.new(PIO_APP_ID)
    # Send the users to PredictionIO.
    User.find_each do |user|
      client.set_user(user.id)
      puts "Sent user #{user.id} to PredictionIO."
    end

    # Send the businesses to PredictionIO.
    Business.find_each do |business|
      client.set_item(business.id, 'properties' => { 'pio_itypes' => ['business'] }) # TODO add in categories!
      # Display progress in the console.
      puts "Sent business #{business.id} to PredictionIO."
    end

    # Send the actions to predictionIO
    Review.find_each do |review|
      # Only send reviews that have a valid user and business.
      if review.user && review.business
        client.record_user_action_on_item(
          'rate',
          review.user.id,
          review.business.id,
          'eventTime' => review.created_at,
          'properties' => { 'pio_rating' => review.stars }
        )
        puts "Sent review #{review.id} from user #{review.user.id} of business #{review.business.id} PredictionIO."
      end
    end
  end
end