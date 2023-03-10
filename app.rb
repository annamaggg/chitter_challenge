require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/accounts_repository'
require_relative 'lib/posts_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('chitter_test')

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/accounts_repository'
    also_reload 'lib/posts_repository'
  end

  get '/' do 
    allposts = PostsRepository.new.all
    @post_feed = allposts.reverse
    return erb(:index)
  end

  get '/posts/new' do 
    return erb(:newpost)
  end

  post '/posts' do
    repo = PostsRepository.new
    post = Post.new
    post.title = params[:title]
    post.content = params[:content]
    post.time_stamp = DateTime.now.strftime
    post.account_id = params[:account_id]

    repo.new(post)
    return erb(:post_created)
  end

  get '/accounts/new' do 
    return erb(:new_account)
  end

  post '/accounts' do 
    repo = AccountsRepository.new
    account = Account.new
    account.username = params[:username]
    account.email = params[:email]

    repo.create(account)
    return erb(:account_created)
  end
end