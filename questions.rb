
require 'SQLite3'
require_relative 'questions_database'

class Question
  attr_accessor :title, :body
  attr_reader :author_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |question| Question.new(question) }
  end


  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end
