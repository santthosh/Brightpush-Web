class Db < ActiveRecord::Base
  establish_connection :db
  self.abstract_class = true
end