require 'posts_repository'
require 'post'
require 'database_connection'


def reset_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    connection.exec(seed_sql)
end
  
describe PostsRepository do
    before(:each) do 
      reset_table
    end
  
    it "returns all posts" do
        repo = PostsRepository.new
        all = repo.all
        expect(all.length).to eq(3)
        expect(all[0].title).to eq('Tuesday')
    end

    it "adds new post" do 
        repo = PostsRepository.new
        post = Post.new
        post.title = 'hello'
        post.content = 'world'
        post.time_stamp = '22nd august'
        post.account_id = '2'
        repo.new(post)

        expect(repo.all.length).to eq(4)
        expect(repo.all.last.title).to eq('hello')
    end

    it "adds new post" do 
        repo = PostsRepository.new
        post = Post.new
        post.title = 'hi'
        post.content = 'hello chitter'
        post.time_stamp = '10th jan'
        post.account_id = '2'
        repo.new(post)

        expect(repo.all.length).to eq(4)
        expect(repo.all.last.title).to eq('hi')

        reset_table
    end
end