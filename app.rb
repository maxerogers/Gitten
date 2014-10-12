require 'sinatra'
require 'rack-flash'
require 'json'
require 'require_all'
require 'sinatra/activerecord'
require 'bcrypt'
require_all 'config' #database configuration
require_all 'models' #model loads

configure do
  enable :sessions
  use Rack::Flash
end

get '/' do

  erb :index
end

get "/repo" do
  erb :repo
end

post '/login' do
  puts params.inspect
  json = {message: "no"}
  if User.where("user_name = ? OR email = ?",params[:email],params[:email]).first.try(:authenticate, params[:password])
    json[:message] = "yes"
  end
  json.to_json
end

post '/signup' do
  puts params.inspect
end

post "/signout" do
  puts params.inspect
end

get '/email_available' do
  content_type :json
  puts params.inspect
  users = User.where(email: params[:email])
  if users.empty?
    return {message: "yes"}.to_json
  else
    return {message: "no"}.to_json
  end
end

get '/user_name_available' do
  content_type :json
  puts params.inspect
  users = User.where(user_name: params[:user_name])
  if users.empty?
    return {message: "yes"}.to_json
  else
    return {message: "no"}.to_json
  end
end


get "/home" do
  erb :home
end

get "/repo2" do
  erb :repo2
end

get "/user/:id" do
  user = User.find(params[:id])
  "Hello, #{user.user_name}!"
end


get "/repo/:id" do
  repo = Repo.find(params[:id])
  "Hello, #{params[:id]}!"
  erb :repo2
end
