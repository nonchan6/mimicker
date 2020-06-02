require 'bundler/setup'
Bundler.require
if development?
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  validates :name,
    format: {with: /\w*/}
  validates :password,
  length: {in: 5..10}
end