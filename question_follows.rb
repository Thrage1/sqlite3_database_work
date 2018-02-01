
require 'SQLite3'
require_relative 'questions_database'
require_relative 'users'

class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |question_follow| QuestionFollow.new(question_follow) }
  end

  def self.find_by_id(id)
    question_follows = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = :id
    SQL
    QuestionFollow.new(question_follows.first)
  end

  def self.find_by_author_id(author_id)
    User.find_by_id(author_id)
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end
