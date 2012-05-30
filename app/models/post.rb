class Post < AWS::Record::Base
	
	set_domain_name $domain_name
	
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
	string_attr :certificate
	string_attr :bundle_id
	string_attr :application_type
	string_attr :c2dm_token
end