require_relative 'post'
require_relative 'database_connection'

class PostsRepository
    def all
        sql = 'SELECT id, title, content, time_stamp, account_id FROM posts;'
        results = DatabaseConnection.exec_params(sql, [])

        posts = []
        
        results.each do |result|
            post = Post.new
            post.id = result['id']
            post.title = result['title']
            post.content = result['content']
            post.time_stamp = result['time_stamp']
            post.account_id = result['account_id']
            posts << post
        end

        return posts 
    end

    def new(post)
        sql = 'INSERT INTO posts (title, content, time_stamp, account_id) VALUES ($1, $2, $3, $4)'
        result = DatabaseConnection.exec_params(sql, [post.title, post.content, post.time_stamp, post.account_id])

        return result
    end
end
