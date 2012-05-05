class Post < ActiveResource::Base
  self.site = "http://localhost:3000" # AwsSdbProxy host + port
  self.prefix = "/com.apple.notifications/"     # use your SimpleDB domain enclosed in /s
end