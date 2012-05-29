class Post < AWS::Record::Base
	
	if request.host == 'brightpush.in'
      domain_name = "in.brighpush.notifications"
    elsif request.host == 'brightpushalpha.in'
      domain_name = "in.brighpushalpha.notifications"
    elsif request.host == 'brightpushbeta.in'
      domain_name = "in.brighpushbeta.notifications"
    else
      domain_name = "in.localhost.notifications"
	end
	
	set_domain_name :domain_name
	
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