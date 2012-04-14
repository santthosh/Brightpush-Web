class Notification < ActiveRecord::Base
  
  belongs_to :app
  acts_as_paranoid
  attr_accessible :badge, :alert, :sound, :payload, :status, :scheduled_count, :dispatched_count, :app_id
  
end