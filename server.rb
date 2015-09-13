###I worked on it with Margaret Morgan!

require 'sinatra'
require 'csv'
require 'pg'
require 'pry'

get '/' do
  erb :index
end

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end

def get_data
  articles = []
  db_connection do |conn|
    articles = conn.exec("SELECT * FROM articles")
  end
  articles
end

get '/articles' do
  articles = get_data
  erb :articles, locals: {articles: articles}
end

get '/articles/new' do
  erb :new_article
end


post '/submit_article' do
  title = params['title']
  url = params['url']
  description = params['description']
  db_connection do |conn|
    conn.exec_params("INSERT INTO articles VALUES ('#{title}', '#{url}', '#{description}')")
  end
  redirect '/articles'
end
