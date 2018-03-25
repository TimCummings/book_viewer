# book_viewer.rb

require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Book Viewer"
  @toc = File.readlines "data/toc.txt"
  erb :home
end

get "/chapters/:number" do |n|
  @title = "Chapter #{n}"
  @toc = File.readlines "data/toc.txt"
  @text = File.read "data/chp#{n}.txt"

  erb :chapter
end
