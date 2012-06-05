set :branch, "develop"
role :web, "brightpushalpha.in"                          # Your HTTP server, Apache/etc
role :app, "brightpushalpha.in"                          # This may be the same as your `Web` server
role :db,  "brightpushalpha.in", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"
ssh_options[:user] = "ubuntu"
ssh_options[:keys] = ["#{File.dirname(__FILE__)}/../../../ops/aws-keys/us-west-oregon/brightpush-web.pem"] 