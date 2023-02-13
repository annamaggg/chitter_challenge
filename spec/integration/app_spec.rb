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
            expect(response.body).to include('<h1>Post was created</h1>')
        end
    end

    context "GET /accounts/new" do 
        it "takes you to create account page" do 
            response = get('/accounts/new')
            expect(response.status).to eq(200)
            expect(response.body).to include('<h1>Create new account</h1>')
        end 

        it "creates an account" do 
            response = post('/accounts', username: 'mistertom', email: 'misterious@email.com')
            expect(response.status).to eq(200)
            expect(response.body).to include('<h1>Account was created</h1>')
            all_accounts = AccountsRepository.new.all
            expect(all_accounts.length).to eq(5)
        end
    end
end