require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
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
  current_user.posts.create(
    person_id: person.id,
    summary: params[:summary],
    body: params[:body]
  )

  post = current_user.posts.last
  post.faces.create(body: params[:characteristic])

  redirect '/'
end
