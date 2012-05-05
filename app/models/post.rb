class Post < ActiveResource::Base
  self.site = "http://newsstandalpha.com/" # AwsSdbProxy host + port
  self.prefix = "/com.apple.notifications/"     # use your SimpleDB domain enclosed in /s
end