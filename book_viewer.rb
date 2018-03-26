# book_viewer.rb

require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Book Viewer"
  @toc = File.readlines "data/toc.txt"
  erb :home
end

get "/chapters/:number" do
  @toc = File.readlines "data/toc.txt"

  chapter_num = params[:number].to_i
  chapter_name = @toc[chapter_num - 1]
  @title = "Chapter #{chapter_num}: #{chapter_name}"

  @text = File.read "data/chp#{chapter_num}.txt"
  erb :chapter
end
