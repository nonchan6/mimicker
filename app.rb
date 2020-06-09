require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'dotenv'
require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

before do
  Dotenv.load
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
  end
end

def person
  Person.find_or_create_by(name: params[:person_name])
end

def face
  Face.find_or_create_by(body: params[:characteristic])
end


get '/' do
  if current_user.nil?
    @posts = Post.none
  else
    @posts = current_user.posts
  end

  @all_posts = Post.all.order('id desc')

  erb :index
end

get '/signin' do
  erb :sign_in
end

get '/signup' do
  erb :sign_up
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

post '/signup' do
  user = User.create(
      name: params[:name],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
      )
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

get '/new' do
  erb :new
end

post '/new' do
  img_url = ''
  if params[:file]
    img = params[:file]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
  end

  current_user.posts.create({
    person_id: person.id,
    summary: params[:summary],
    body: params[:body],
    image: img_url
  })

  post = current_user.posts.last
  post.faces.create(body: params[:characteristic])


  redirect '/'
end

get '/search' do
  erb :search
end

post '/search' do
  @person_posts = Post.where(person_id: Person.find_by(name: params[:person]))
  @person_posts_name = Person.find_by(name: params[:person]).name
  erb :result
end

get '/mypage/:id' do
  @posts = current_user.posts.order('id desc')
  erb :mypage
end

post '/good/:id' do
  post = Post.find(params[:id])
  like = post.likes.create({
    user_id: current_user.id
  })

  redirect '/'
end

post '/delete/:id' do
  Post.find(params[:id]).destroy
  redirect '/mypage/:id'
end

get '/edit/:id' do
  @post = Post.find(params[:id])
  erb :edit
end

post '/renew/:id' do
  post = Post.find(params[:id])
  post.update(body: params[:body])
  redirect '/mypage/:id'
end

get "/mypage/:id/like" do
=begin
  if Like.find_by(user_id: params[:id]).nil?
    @like_posts = Post.none
  else
    @like_posts = Post.find(Like.find_by(user_id: params[:id]).post_id)
  end
=end
  erb :mylike
end