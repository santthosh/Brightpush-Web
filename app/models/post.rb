<<<<<<< HEAD
class Post < ActiveResource::Base
  self.site = "http://localhost:8888" # AwsSdbProxy host + port
  self.prefix = "/my_new_domain/"     # use your SimpleDB domain enclosed in /s
end
=======
class Post < AWS::Record::Base
  string_attr :message
	string_attr :environment
	string_attr :scheduler_id
	string_attr :status
	string_attr :application_id
	string_attr :timeout
	string_attr :updated
	string_attr :created
	string_attr :alias
	string_attr :active
	string_attr :last_registration

end
>>>>>>> develop
