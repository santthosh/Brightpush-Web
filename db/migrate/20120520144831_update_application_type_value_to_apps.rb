class UpdateApplicationTypeValueToApps < ActiveRecord::Migration
  # update application type in old records
  def change
    App.all.each do |app|
      if app.application_type.blank?
	app.application_type = "ios"
	app.save!(validate: false)
      end
    end
  end
end
