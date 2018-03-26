# book_viewer.rb

require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      '<p>' + paragraph + '</p>'
    end.join
  end
end

before do
  @toc = File.readlines "data/toc.txt"
end

get "/" do
  @title = "Book Viewer"

  erb :home
end

get "/chapters/:number" do
  chapter_num = params[:number].to_i

  redirect '/' unless (1..@toc.size).cover? chapter_num

  chapter_name = @toc[chapter_num - 1]
  @title = "Chapter #{chapter_num}: #{chapter_name}"
  @text = File.read "data/chp#{chapter_num}.txt"

  erb :chapter
end

not_found do
  redirect '/'
end
