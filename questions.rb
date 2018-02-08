
require 'SQLite3'
require_relative 'questions_database'
require_relative 'model_base'

class Question < ModelBase
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

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, title: title, body: body, id: id)
        UPDATE
          questions
        SET
          title = :title, body = :body
        WHERE
          id = :id
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, title: title, body: body, author_id: author_id)
        INSERT INTO
          questions(title, body, author_id)
        VALUES
          (:title, :body, :author_id)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end
