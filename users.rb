
require 'SQLite3'
require_relative 'questions_database'
require_relative 'questions'
require_relative 'model_base'


class User < ModelBase
  attr_accessor :fname, :lname
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname, id: id)
        UPDATE
          users
        SET
          fname = :fname, lname = :lname
        WHERE
          id = :id
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
        INSERT INTO
          users(fname, lname)
        VALUES
          (:fname, :lname)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

  # def self.find_by_id(id)
  #   user = QuestionsDatabase.instance.execute(<<-SQL, id: id)
  #     SELECT
  #       *
  #     FROM
  #       users
  #     WHERE
  #       id = :id
  #   SQL
  #   User.new(user.first)
  # end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
    SQL

    User.new(user.first)
  end

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |user| User.new(user)  }
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def num_authored_questions
    num = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      select
        count(*) as count
      from
        questions
      where
        questions.author_id = :id
      group by author_id
    SQL
    if (num.first)
      num.first['count']
    else
      0
    end
  end

  def average_karma
    num_questions_asked = self.num_authored_questions
    if num_questions_asked == 0
      0
    else
      total_likes = 0
      self.authored_questions.each { |question| total_likes += question.num_likes }
      total_likes.to_f/num_questions_asked.to_f
    end
  end
end
