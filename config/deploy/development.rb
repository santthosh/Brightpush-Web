set :branch, "develop"
# This IP 50.112.125.184 is CNAME'D to brightpushalpha.in
role :web, "50.112.125.184"                          # Your HTTP server, Apache/etc
role :app, "50.112.125.184"                          # This may be the same as your `Web` server
role :db,  "50.112.125.184", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

ssh_options[:user] = "ubuntu"
ssh_options[:keys] = ["/data/ops/alpha/aws-keys/us-west-oregon/brightpush-web.pem"] 