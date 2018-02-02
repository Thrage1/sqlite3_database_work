
require 'SQLite3'
require_relative 'questions_database'

class Question
  attr_accessor :title, :body
  attr_reader :author_id, :id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |question| Question.new(question) }
  end

  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id: author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = :author_id
    SQL
    questions.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id
    SQL
    Question.new(question.first)
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end


end
