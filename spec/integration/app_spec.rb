require "spec_helper"
require 'rack/test'
require_relative '../../app'


def reset_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    connection.exec(seed_sql)
end
  
describe Application do
    before(:each) do 
      reset_table
    end

    include Rack::Test::Methods

    # We need to declare the `app` value by instantiating the Application
    # class so our tests work.
    let(:app) { Application.new }

    context "POST /posts" do 
        it "adds a post" do 
            response = post('/posts', title: 'Friday', content: 'I am super happy', time_stamp: DateTime.now.strftime, account_id: '2')

            expect(response.status).to eq(200)
            expect(response.body).to include('Post was created')
        end
    end

    context "GET /accounts/new" do 
        it "takes you to create account page" do 
            response = get('/accounts/new')
            expect(response.status).to eq(200)
            expect(response.body).to include('Create new account')
        end 

        it "creates an account" do 
            response = post('/accounts', username: 'mistertom', email: 'misterious@email.com', passkey: 'pass5')
            expect(response.status).to eq(200)
            expect(response.body).to include('Account was created')
            all_accounts = AccountsRepository.new.all
            expect(all_accounts.length).to eq(5)
            expect(all_accounts.last.passkey).to eq('pass5')
        end
    end

    context "GET /signup and POST /signup" do 
        it "takes you to signup page" do 
            response = get('signup')
            expect(response.status).to eq(200)
        end

        it "signs up a user" do 
            all_accounts = AccountsRepository.new.all.length
            response = post('/signup', username: 'gob', email: 'gob@gob.com', passkey: '123')
            all_accounts_updated = AccountsRepository.new.all.length
            expect(response.status).to eq(200)
            expect(response.body).to include('Account was created')
            expect(all_accounts_updated).to eq(all_accounts + 1)
        end
    end

    context "POST /login" do 
        it "throws error when password incorrect" do
            response = post('/login', username: 'go4554', password: 'hello')
            expect(response.status).to eq(200)
            expect(response.body).to include('Password is incorrect, please try again')
        end
        it "throws error when username doesnt exist" do 
            response = post('/login', username: 'abcd', password: 'efg')
            expect(response.status).to eq(200)
            expect(response.body).to include("Username does not exist")
        end
        it "logs in successfully and creates session" do 
            response = post('/login', username: 'am02034', passkey: 'pass1')
            
            expect(response.body).to include('Logged in successfully')
            expect(response.status).to eq(200)
        end
        it "logs out successfully and ends session" do 
            response = post('/login', username: 'am02034', passkey: 'pass1')
            expect(response.body).to include('Logged in successfully')
            expect(response.status).to eq(200)

            response1 = get('/')
            expect(response1.status).to eq(200)
            expect(response1.body).to include('Chitter')
            expect(response1.body).to include('am02034')

            response2 = get('/logout')
            response3 = get('/')
            expect(response3.status).to eq(200)
            expect(response3.body).to include('Chitter')
            expect(response3.body).to include('login')
        end
    end
end