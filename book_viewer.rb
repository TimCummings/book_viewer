# book_viewer.rb

require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, idx|
      "<p id=p#{idx + 1}>" + paragraph + "</p>"
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

get "/search" do
  @search_results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect '/'
end

def chapters_matching(query)
  return [] if !query || query.empty?

  each_chapter.with_object([]) do |chapter, results|
    results << chapter if chapter[:contents].include? query
  end
end

def each_chapter
  return enum_for(:each_chapter) unless block_given?

  @toc.each_with_index do |name, idx|
    chapter = {}
    chapter[:number] = idx + 1
    chapter[:name] = name
    chapter[:contents] = File.read("data/chp#{chapter[:number]}.txt")
    yield chapter
  end
end
