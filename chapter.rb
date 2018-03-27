# chapter.rb

class Chapter
  attr_reader :title, :number

  def initialize(title, number)
    @title = title
    @number = number
  end

  def content
    File.read "data/chp#{number}.txt"
  end

  def paragraphs
    content.split("\n\n")
  end

  def to_s
    "#{number}: #{title}"
  end
end
