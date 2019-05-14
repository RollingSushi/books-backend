require 'sinatra'
require 'json'
require 'sinatra/cors'
require 'sqlite3'

set :allow_origin,'http://localhost:1234'
set :allow_methods,'GET,POST,DELETE,PATCH,PUT'
db = SQLite3::Database.new 'test.db'

db.execute <<-SQL
  create table if not exists books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    author_name TEXT,
    isbn int
  );
SQL


get '/books' do
    rows = db.execute('SELECT * FROM books')
    return rows.map { |row|
        {
            :id => row[0],
            :name => row[1],
            :author_name => row[2],
            :isbn => row[3]
        }
    }.to_json
end

get '/books/:book_id' do
    rows = db.execute('SELECT * FROM books WHERE id = ?', params['book_id'])
    return rows.to_json
end

post '/books' do
    json_body = JSON.parse request.body.read
    db.execute('INSERT INTO books (name, author_name, isbn) VALUES ( ?, ?, ? )', json_body['name'], json_body['author_name'], json_body['isbn'])
           
end

delete '/books/:book_id' do
    db.execute('DELETE FROM books WHERE id = ?', params['book_id'])
    #supply_of_books.select {|'book.id'| 'book.id' = }
end

put '/books/:book_id' do
    json_body = JSON.parse request.body.read
    db.execute('UPDATE books SET name = ?, author_name = ?, isbn = ? WHERE id = ?', json_body['name'], json_body['author_name'], json_body['isbn'], params['book_id'])
    #supply_of_books.select {|'book.id'| 'book.id' = }
end

set :port, 8080