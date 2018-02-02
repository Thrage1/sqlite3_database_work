
require 'SQLite3'
require_relative 'questions_database'
require_relative 'users'
require_relative 'questions'

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

  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
    SELECT
      *
    FROM
      users
    JOIN
      question_follows
    ON
      question_follows.user_id = users.id
    WHERE
      question_id = :question_id
    SQL
    users.map { |user| User.new(user)  }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
      ON
        question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = :user_id
    SQL
    questions.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    followed_questions = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        *, count(*)
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        count(*) DESC
      LIMIT
        :n
    SQL
    followed_questions.map { |question| Question.new(question) }
  end
end
