require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/accounts_repository'
require_relative 'lib/posts_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('chitter_test')

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/accounts_repository'
    also_reload 'lib/posts_repository'
  end

  get '/signup' do 
    return erb(:sign_up)
  end

  post '/signup' do 
    repo = AccountsRepository.new
    account = Account.new
    account.username = params[:username]
    account.email = params[:email]
    account.passkey = params[:passkey]

    repo.create(account)
    return erb(:account_created)
  end

  get '/login' do 
    return erb(:login)
  end

  post '/login' do 
    #return status 400 unless %i[username password].all? { |param| params.key?(param) }
    account_repo = AccountsRepository.new
    all_accounts = account_repo.all_usernames

    if all_accounts.include? params[:username]

      account = account_repo.find_by_username(params[:username])

      if params[:passkey] == account.passkey
        session.clear
        session[:user_id] = account.id
        if session[:user_id] == nil
          return "no session"
        else
          # redirect '/login_success'
          erb(:login_success)
        end
      else
        @error = "Password is incorrect, please try again"
        erb(:login)
      end
    else 
      @error = "Username does not exist"
      erb(:login)
    end
  end 

  get '/logout' do
    session.clear
        if session[:user_id] == nil
          puts "no login session"
        else
          puts "still logged in"
        end
    redirect '/'
  end

  get '/' do 
    current_user_id = session[:user_id]

    if current_user_id
      @loggedin = true
      user_repo = AccountsRepository.new
      @user = user_repo.find_by_id(current_user_id)
      @message = "successfully logged in!"
    else
      @loggedin = false
      @message = "not logged in"
    end

    puts "login session=" + @loggedin.to_s
    puts "user =" + @user.to_s

    allposts = PostsRepository.new.all
    @post_feed = allposts.reverse
    return erb(:index)
  end

  get '/login_success' do 
    current_user_id = session[:user_id]
    if current_user_id
      @session = "session still here"
    else
      @session = "no session"
    end
    @test = "hello"
    return erb(:login_success)
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
    account.passkey = params[:passkey]

    repo.create(account)
    return erb(:account_created)
  end
end