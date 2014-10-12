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
  set :session_secret, "My session secret"
  use Rack::Flash
end

get '/' do
  redirect to("/home")
end

get "/repo" do
  erb :repo
end

post '/login' do
  puts params.inspect
  json = {message: "no"}
  user = User.where("user_name = ? OR email = ?",params[:email],params[:email]).first.try(:authenticate, params[:password])
  if user
    session[:current_user] = user
    json[:message] = "yes"
  end
  json.to_json
end

post '/signup' do
  puts params.inspect
  json = {message: "no"}
  user = User.create(user_name: params[:user_name],email: params[:email],password: params[:password],  password_confirmation: params[:password_confirm])
  if user
    session[:current_user] = user
    json[:message] = "yes"
  end
  json.to_json
end

get "/signout" do
  puts params.inspect
  session[:current_user] = nil
  redirect back
end

get '/email_available' do
  content_type :json
  puts params.inspect
  if User.where(email: params[:email]).empty?
    return {message: "yes"}.to_json
  else
    return {message: "no"}.to_json
  end
end

get '/user_name_available' do
  content_type :json
  puts params.inspect
  if User.where(user_name: params[:user_name]).empty?
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
