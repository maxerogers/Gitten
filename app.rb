require 'sinatra'
require 'rack-flash'
require 'json'
require 'require_all'
require 'sinatra/activerecord'
require 'bcrypt'
require 'omniauth-github'
require 'httparty'
require 'rufus-scheduler'
require_all 'config' #database configuration
require_all 'models' #model loads

configure do
  #use Rack::Session::Pool
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

after { ActiveRecord::Base.connection.close }

get '/auth/github/callback' do
    env['omniauth.auth']
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
  "Hello, #{@user.user_name}!"
end

def gen_mews(repo)
  #curl -i 'https://api.github.com/repos/honeycodedbear/gitter/compare/aa5a8bd2c5f5b648ab84344ee3fe90457a3dbb25...b8262a36c765127924b5c424005a695fde02298c?client_id=5394720ddae7b4107128&client_secret=96a96f7a666b4dfa0708a881c56edac9c702dbb0'
  #curl -i 'https://api.github.com/repos/honeycodedbear/gitter/compare/aa5a8bd2c5f5b648ab84344ee3fe90457a3dbb25...b8262a36c765127924b5c424005a695fde02298c?client_id=5394720ddae7b4107128&client_secret=96a96f7a666b4dfa0708a881c56edac9c702dbb0'
  repoStrs = repo.repo_link.split("/")
  owner = repoStrs[3]
  repo_name = repoStrs[4].split(".")[0]
  url = "https://api.github.com/repos/#{owner}/#{repo_name}"
  #HTTParty.get("")
  response = HTTParty.get("#{url}/commits?client_id=#{$github_id}&client_secret=#{$github_secret}", headers: {"User-Agent" => 'gitten', "Accept" => "application/vnd.github.v3+json"})
  #puts response.body, response.code, response.message, response.headers.inspect
  jsons = JSON.parse(response.body)
  jsons.each do |json|
    Mew.create(time_string: json["commit"]["committer"]["date"], message: json["commit"]["message"], author: json["commit"]["author"]["name"], repo_id: repo.id)
  end
end

get "/repo/:id" do
  @user = session[:current_user]
  @repo = Repo.find(params[:id])
  repoStrs = @repo.repo_link.split("/")
  owner = repoStrs[3]
  repo_name = repoStrs[4].split(".")[0]
  url = "https://api.github.com/repos/#{owner}/#{repo_name}"
  #HTTParty.get("")
  response = HTTParty.get("#{url}/commits?client_id=#{$github_id}&client_secret=#{$github_secret}", headers: {"User-Agent" => 'gitten', "Accept" => "application/vnd.github.v3+json"})
  #puts response.body, response.code, response.message, response.headers.inspect
  json = JSON.parse(response.body)

  @commit_feeds = []
  json

  erb :repo3
end



get '/git_test' do
  @repo = Repo.last
  #curl -i 'https://api.github.com/repos/honeycodedbear/gitter/compare/aa5a8bd2c5f5b648ab84344ee3fe90457a3dbb25...b8262a36c765127924b5c424005a695fde02298c?client_id=5394720ddae7b4107128&client_secret=96a96f7a666b4dfa0708a881c56edac9c702dbb0'
  #curl -i 'https://api.github.com/repos/honeycodedbear/gitter/compare/aa5a8bd2c5f5b648ab84344ee3fe90457a3dbb25...b8262a36c765127924b5c424005a695fde02298c?client_id=5394720ddae7b4107128&client_secret=96a96f7a666b4dfa0708a881c56edac9c702dbb0'
  Mew.where(repo: @repo).delete_all
  repoStrs = @repo.repo_link.split("/")
  owner = repoStrs[3]
  repo = repoStrs[4].split(".")[0]
  url = "https://api.github.com/repos/#{owner}/#{repo}"
  #HTTParty.get("")
  response = HTTParty.get("#{url}/commits?client_id=#{$github_id}&client_secret=#{$github_secret}", headers: {"User-Agent" => 'gitten', "Accept" => "application/vnd.github.v3+json"})
  #puts response.body, response.code, response.message, response.headers.inspect
  jsons = JSON.parse(response.body)
  jsons.each do |json|
    Mew.create(time_string: json["commit"]["committer"]["date"], message: json["commit"]["message"], author: json["commit"]["author"]["name"], repo_id: @repo.id)
  end
  #"#{jsons[0]}"
  redirect to("/repo/#{@repo.id}")
end

post '/repo' do
  content_type :json
  if Repo.create(user: session[:current_user], blurb: params[:blurb], demo_link: params[:demo],
                  repo_link: params[:github], date_location: params[:location], title: params[:title])
    {message: "#{Repo.last.id}"}.to_json
  else
    {message: "no"}.to_json
  end
end

post '/follow/:id' do
  content_type :json
  following = Following.create(u: session[:current_user], r: Repo.find(params[:id]))
  if following
    {message: "yes"}.to_json
  else
    {message: "no"}.to_json
  end
end

post '/unfollow/:id' do
  content_type :json
  following = Following.where(u: session[:current_user], r: Repo.find(params[:id])).first
  if following
    following.delete
    {message: "yes"}.to_json
  else
    {message: "no"}.to_json
  end
end

post '/repo/:id/edit' do
  content_type :json
  temp_repo = Repo.find(params[:id])
  if temp_repo
    temp_repo.title = params[:title]
    temp_repo.date_location = params[:date_location]
    temp_repo.demo_link = params[:demo_url]
    temp_repo.repo_link = params[:repo_url]
    temp_repo.blurb = params[:blurb]
    temp_repo.tags = []
    params[:tags].split(",").each do |tag|
      temp_tag = Tag.where(name: tag).first
      if temp_tag
        temp_repo.tags.push temp_tag
      else
        Tag.create(name: tag)
        temp_repo.tags.push Tag.last
      end
    end
    temp_repo.save
    {message: "yes"}.to_json
  else
    {message: "no"}.to_json
  end
end

post '/repo/:id/delete' do
  content_type :json
  temp_repo = Repo.find(params[:id])
  unless temp_repo.nil? && temp_repo.user.id != session[:current_user].id
    temp_repo.delete
    {message: "yes"}.to_json
  else
    {message: "no"}.to_json
  end
end

post "/search" do
  @search_params = params[:search]
  search_strs = @search_params.split(",")
  repos = []
  search_strs.each do |str|
    tag = Tag.where(name: str).first
    puts tag.inspect
    repos.push tag.repos unless tag.nil?
  end
  @repos = nil
  repos.each do |r|
    if @repos.nil?
      @repos = r
    else
      @repos.concat r
    end
  end
  @repos = @repos.uniq
  @repos_sort = {}
  @repos.each { |repo| @repos_sort[repo] = repo.us.count }
  #@repos = @repos_sort.sort_by {|_key, value| value}
  @mews = []
  erb :search
end

post "/comment/new" do
  content_type :json
  if Comment.create(user: session[:current_user], repo: Repo.find(params[:repo]), message: params[:message])
    {message: "yes"}.to_json
  else
    {message: "no"}.to_json
  end
end

peon = Rufus::Scheduler.new
if ARGV[0] == "peon"
  peon.in '10s' do
    Mew.delete_all
    Repo.all.each do |repo|
      gen_mews(repo)
    end
    puts "Work Complete"
  end
end
