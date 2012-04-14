class Notification < ActiveRecord::Base
  
  belongs_to :app
  acts_as_paranoid
  attr_accessible :badge, :alert, :sound, :payload, :status, :scheduled_count, :dispatched_count, :app_id
  
  validates_presence_of :badge
  validates_presence_of :alert
  validate :is_badge
  
  def is_badge
    if self.badge == 0 
      errors.add :badge, " must be an integer"
    end
  end
end