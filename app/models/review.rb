class Review < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :business
end
