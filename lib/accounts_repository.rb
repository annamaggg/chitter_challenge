require_relative 'account'
require_relative 'database_connection'

class AccountsRepository

    # Selecting all records
    # No arguments
    def all
      # Executes the SQL query:
      sql = 'SELECT id, username, email FROM accounts;'
      results = DatabaseConnection.exec_params(sql, [])
      
      accounts = []
      results.each do |item|
        account = Account.new
        account.id = item['id']
        account.username = item['username']
        account.email = item['email']
        accounts << account
      end
      return accounts
    end
  
    # Gets a single record by its ID
    # One argument: the id (number)
    def find(id)
      # Executes the SQL query:
      # SELECT id, name, cohort_name FROM students WHERE id = $1;
  
      # Returns a single Student object.
    end
  
    # Add more methods below for each operation you'd like to implement.
  
    # def create(student)
    # end
  
    # def update(student)
    # end
  
    # def delete(student)
    # end
end