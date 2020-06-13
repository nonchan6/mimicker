require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_secure_password
  validates :name,
    presence: true,
    format: { with: /\A\w+\z/ }
  validates :password,
    length: {in: 5..10}
  has_many :posts
  has_many :likes
end

class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :person
  has_many :likes, dependent: :destroy
  has_many :face_posts, dependent: :destroy
  has_many :faces, through: :face_posts
end

class Person < ActiveRecord::Base
  has_many :posts
end

class Like < ActiveRecord::Base
  belongs_to :post, counter_cache: true
  belongs_to :user
end

class Face < ActiveRecord::Base
  has_many :face_posts
  has_many :posts, through: :face_posts
end

class FacePost < ActiveRecord::Base
  belongs_to :post
  belongs_to :face
end