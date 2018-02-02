
require 'SQLite3'
require_relative 'questions_database'

class QuestionLike
  attr_accessor :user_id, :question_id
  attr_reader :id
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |question_like| QuestionLike.new(question_like) }
  end

  def self.find_by_id(id)
    question_like = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
    SQL
    QuestionLike.new(question_like.first)
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.likers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_likes
      ON
        question_likes.user_id = users.id
      WHERE
        question_id = :question_id
    SQL
    users.map { |user| User.new(user) }
  end

  # The reason for this query instead of just using
  # QuestionLike#likers_for_question_id is because
  # that would query for more data = slower

  def self.num_likes_for_question_id(question_id)
    num = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        COUNT(*) as count
      FROM
        questions
      JOIN
        question_likes
      ON
        question_likes.question_id = questions.id
      WHERE
        question_id = :question_id
    SQL
    num.first['count']
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = :user_id
    SQL
      questions.map { |question| Question.new(question) }
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n: n)
    SELECT
      *, COUNT(*) AS count
    FROM
      questions
    JOIN
      question_likes
    ON
      questions.id = question_likes.id
    GROUP BY
      questions.id
    ORDER BY
      count DESC
    LIMIT
      :n
    SQL
    questions.map { |question| Question.new(question) }
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id, user_id: user_id, id: id)
      UPDATE
        question_likes
      SET
        question_id = :question_id, user_id = :user_id
      WHERE
        id = :id
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id, user_id: user_id)
      INSERT INTO
        question_likes(question_id, user_id)
      VALUES
        (:question_id, :user_id)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end
