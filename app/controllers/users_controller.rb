class UsersController < ApplicationController
  def index
    @users = User.order('reviews_count DESC').limit(20)
  end

  def show
    # Find the correct user.
    @user = User.find(params[:id])

    # Find 10 recent reviews by the user. We use eager loading here to reduce database queries.
    @recent_reviews = @user.reviews.includes(:business).order('created_at DESC').limit(10)

    # Create new PredictionIO client.
    client = PredictionIO::EngineClient.new(ENV['PIO_APP_ID'], ENV['PIO_URL'])

    # Query PredictionIO for 5 recommendations!
    object = client.send_query('uid' => @user.id, 'n' => 5)

    # Initialize empty recommendations array.
    @recommendations = []

    # Loop though item recommendations returned from PredictionIO.
    object['items'].each do |item|
      # Initialize empty recommendation hash.
      recommendation = {}

      # Each item hash has only one key value pair so the first key is the item ID (in our case the business ID).
      business_id = item.keys.first

      # Find the business.
      business = Business.find(business_id)
      recommendation[:business] = business

      # The value of the hash is the predicted preference score.
      score = item.values.first
      recommendation[:score] = score

      # Add to the array of recommendations.
      @recommendations << recommendation
    end
  end
end