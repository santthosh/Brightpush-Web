class Notification < ActiveRecord::Base

  PREPARING = 1
  SCHEDULING = 2
  DISPATCHING = 3
  DONE = 4
  
  before_create :add_defaults
  belongs_to :app
  acts_as_paranoid
  attr_accessible :badge, :alert, :sound, :payload, :status, :scheduled_count, :dispatched_count, :app_id, :certificate, :extra_key, :extra_value
  attr_accessor :certificate_file_name
  
  has_attached_file( :certificate, {:storage => :s3}.merge(PaperclipConfig.certificate))
  
  validates_presence_of :badge, :if => :ios_application?
  validates_presence_of :alert
  validate :is_badge, :if => :ios_application?
  
  def is_badge
    if self.badge == 0
      errors.add :badge, " must be an integer"
    end 
  end
  
  def status_is_preparing?
    (self.status & PREPARING) != 0
  end
  
  def status_is_scheduling?
    (self.status & SCHEDULING) != 0
  end
  
  def status_is_dispatching?
    (self.status & DISPATCHING) != 0
  end
  
  def status_is_done?
    (self.status & DONE) != 0
  end
  
  def add_defaults
    self.status = 1
  end
  
  def ios_application?
    application = App.find(self.app_id)
    application.application_type == 'ios'
  end
	
  def random_string_timestamp(size = 8)
    chars = (('a'..'z').to_a + ('0'..'9').to_a + Time.now.to_a) - %w(i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end
end
