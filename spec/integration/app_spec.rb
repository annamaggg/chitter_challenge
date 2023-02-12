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
end