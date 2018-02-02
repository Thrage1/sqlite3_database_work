
require 'SQLite3'
require_relative 'questions_database'

class Reply
  attr_accessor :user_id, :question_id, :parent_reply_id, :body
  attr_reader :id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |reply| Reply.new(reply) }
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :id
    SQL
    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = :user_id
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = :question_id
    SQL
    replies.map { |reply| Reply.new(reply)  }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    if parent_reply_id
      Reply.find_by_id(parent_reply_id)
    else
      p 'there is no parent reply'
    end
  end

  def child_reply
    reply = QuestionsDatabase.instance.execute(<<-SQL, id: self.id)
    SELECT
    *
    FROM
    replies
    WHERE
    parent_reply_id = :id
  SQL
    if reply.first
      Reply.new(reply.first)
    else
      p 'no parent replies'
    end
  end

end
