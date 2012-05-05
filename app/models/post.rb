class Post < ActiveResource::Base
  self.site = "http://localhost:8888" # AwsSdbProxy host + port
  self.prefix = "/my_new_domain/"     # use your SimpleDB domain enclosed in /s
end