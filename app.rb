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
  if User.where("email = ? OR user_name = ?", params[:email], params[:email]).first.try(:authenticate, params[:password])
    return erb :repo
  end
  flash[:notice] = "Incorrect Email/Username and Password combination"
  erb :index
end

post '/signup' do
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
