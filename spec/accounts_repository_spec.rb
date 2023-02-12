require 'accounts_repository'
require 'database_connection'

def reset_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    connection.exec(seed_sql)
end
  
describe AccountsRepository do
    before(:each) do 
      reset_table
    end
  
    it "returns all accounts" do
        repo = AccountsRepository.new
        all = repo.all
        expect(all.length).to eq(4)
        expect(all[0].username).to eq('am02034')
    end
end