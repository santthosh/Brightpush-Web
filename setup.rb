#include AWS::S3
require 'aws/s3'

system("rake db:create")
system("rake db:migrate")
system("rake db:migrate test")
system("rake saas:bootstrap")

AWS::S3::Base.establish_connection!(
 :access_key_id     => 'AKIAIERRYQXDX7KCTHPQ',
 :secret_access_key => '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'
)

if ARGV[0] == 'live'
  AWS::S3::Bucket.create('brightpush_application_icons')
  AWS::S3::Bucket.create('brightpush_development_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('brightpush_production_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('brightpush_ios_certificates_pem')
  AWS::S3::Bucket.create('brightpush_c2dm_token_txt')
elsif ARGV[0] == 'alpha'
  AWS::S3::Bucket.create('alpha_brightpush_application_icons')
  AWS::S3::Bucket.create('alpha_brightpush_development_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('alpha_brightpush_production_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('alpha_brightpush_ios_certificates_pem')
  AWS::S3::Bucket.create('alpha_brightpush_c2dm_token_txt')
elsif ARGV[0] == 'beta'
  AWS::S3::Bucket.create('beta_brightpush_application_icons')
  AWS::S3::Bucket.create('beta_brightpush_development_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('beta_brightpush_production_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('beta_brightpush_ios_certificates_pem')
  AWS::S3::Bucket.create('beta_brightpush_c2dm_token_txt')
else
  AWS::S3::Bucket.create('local_brightpush_application_icons')
  AWS::S3::Bucket.create('local_brightpush_development_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('local_brightpush_production_ios_certificate_pkcs12')
  AWS::S3::Bucket.create('local_brightpush_ios_certificates_pem')
  AWS::S3::Bucket.create('local_brightpush_c2dm_token_txt')
end