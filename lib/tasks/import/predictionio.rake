namespace :import do
  desc 'Send the data to PredictionIO'
  task predictionio: :environment do
    client = PredictionIO::EventClient.new(ENV['PIO_APP_ID'].to_i, ENV['PIO_EVENT_SERVER_URL'])

    # Send the users to PredictionIO.
    User.find_each do |user|
      begin
        client.set_user(user.id)
        puts "Sent user #{user.id} to PredictionIO."
      rescue => e
        puts "Error! User #{user.id} failed. #{e.message}"
      end
    end

    # Send the businesses to PredictionIO.
    Business.find_each do |business|
      begin
        client.set_item(business.id, 'properties' => { 'pio_itypes' => ['business'] }) # TODO add in categories!
        # Display progress in the console.
        puts "Sent business #{business.id} to PredictionIO."
      rescue => e
        puts "Error! Business #{business.id} failed. #{e.message}"
      end
    end

    # Send the actions to predictionIO
    Review.find_each do |review|
      begin
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
      rescue => e
        puts "Error! Review #{review.id} failed. #{e.message}"
      end
    end
  end
end