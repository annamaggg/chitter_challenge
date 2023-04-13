require_relative 'account'
require_relative 'database_connection'

class AccountsRepository

    # Selecting all records
    # No arguments
    def all
      # Executes the SQL query:
      sql = 'SELECT id, username, email, passkey FROM accounts;'
      results = DatabaseConnection.exec_params(sql, [])
      
      accounts = []
      results.each do |item|
        account = Account.new
        account.id = item['id']
        account.username = item['username']
        account.email = item['email']
        account.passkey = item['passkey']
        accounts << account
      end
      return accounts
    end
  
    def find_by_username(username)
      sql = 'SELECT id, username, email, passkey FROM accounts WHERE username = $1;'
      params = [username]
      result = DatabaseConnection.exec_params(sql, params).first

      account = Account.new
      account.id = result['id'].to_i
      account.username = result['username']
      account.email = result['email']
      account.passkey = result['passkey']
      
      return account
    end

    def find_by_id(id)
      sql = 'SELECT id, username, email, passkey FROM accounts WHERE id = $1;'
      params = [id]
      result = DatabaseConnection.exec_params(sql, params).first

      account = Account.new
      account.id = result['id'].to_i
      account.username = result['username']
      account.email = result['email']
      account.passkey = result['passkey']
      
      return account
    end

    def all_usernames
      sql = 'SELECT * FROM accounts;'
      results = DatabaseConnection.exec_params(sql, [])

      usernames = []

      results.each do |record|
        usernames << record['username']
      end
      return usernames
    end
  
    # Add more methods below for each operation you'd like to implement.
  
    def create(account)
      sql = 'INSERT INTO accounts (username, email, passkey) VALUES ($1, $2, $3)'
        result = DatabaseConnection.exec_params(sql, [account.username, account.email, account.passkey])

        return result
    end
  
    # def update(student)
    # end
  
    # def delete(student)
    # end
end