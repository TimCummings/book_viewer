# book_viewer.rb

require 'tilt/erubis'
require 'sinatra'
require 'sinatra/reloader'

require_relative 'chapter'

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, idx|
      "<p id=p#{idx + 1}>" + paragraph + "</p>"
    end.join
  end
end

before do
  toc = File.readlines("data/toc.txt")
  @chapters = toc.each_with_index.with_object([]) do |(name, idx), chapters|
    chapters << Chapter.new(name, idx + 1)
  end
end

get "/" do
  @title = "Book Viewer"
  erb :home
end

get "/chapters/:number" do
  chapter_num = params[:number].to_i
  redirect '/' unless (1..@chapters.size).cover? chapter_num
  @chapter = @chapters[chapter_num - 1]
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

  @chapters.each.with_object([]) do |chapter, results|
    results << chapter if chapter.content.include? query
  end
end
