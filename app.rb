require 'sinatra'
require 'rack-flash'
require 'json'
require 'require_all'
require 'sinatra/activerecord'
require 'bcrypt'
require 'omniauth-github'
require 'httparty'
require_all 'config' #database configuration
require_all 'models' #model loads

configure do
  enable :sessions
  set :session_secret, "My session secret"
  $github_id = 'c57c82472c219e5c4e6b'
  $github_secret = '4c4b45a2bc3ccd12b73860a204834382662035d9'
  use Rack::Flash
  use OmniAuth::Builder do
    #I know this bad form but I haven't deployed yet. So Shhhhhhhh
    provider :github, $github_id, $github_secret
  end
end

get '/auth/github/callback' do
    env['omniauth.auth']
end

get '/git_test' do
  response = HTTParty.get("https://api.github.com/repos/honeycodedbear/gitter/commits?client_id=#{$github_id}&client_secret=#{$github_secret}", headers: {"User-Agent" => 'gitten', "Accept" => "application/vnd.github.v3+json"})
  #puts response.body, response.code, response.message, response.headers.inspect
  json = JSON.parse(response.body)
  puts json[0]
  "#{response.body}"
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
  user = User.create(user_name: params[:username],email: params[:email],password: params[:password],  password_confirmation: params[:password_confirm])
  puts user.inspect
  if user
    puts "I MADE A USER!!!"
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
  @test = "RWAR" #Do this to pass temp variables
  @user = session[:current_user]
  @repos = Repo.all
  erb :home, :locals => {:test => 1} #do this to pass local variables
end

get "/repo2" do
  erb :repo2
end

get "/user/:id" do
  @user = User.find(params[:id])
  "Hello, #{user.user_name}!"
end


get "/repo/:id" do
  @repo = Repo.find(params[:id])
  "Hello, #{params[:id]}!"
  erb :repo2, :locals => {:test => 1}
end


post '/repo' do
  puts params.inspect
  json = {message: "no"}
  repo = Repo.create(title: params[:title], date_location: params[:location],
  demo_link: params[:demo],  repo_link: params[:github],
  blurb: params[:blurb],
  user_id: session[:current_user].id )
  puts repo.inspect
  if repo
    puts "I MADE A REPO!!!"
    json[:message] = "yes"
    redirect "/repo/#{repo.id}"
  end
  json.to_json
end
