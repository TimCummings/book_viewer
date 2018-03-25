# book_viewer.rb

require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Book Viewer"
  @toc = File.readlines "data/toc.txt"
  erb :home
end
