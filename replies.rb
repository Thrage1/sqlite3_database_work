
require 'SQLite3'
require_relative 'questions_database'

class Reply
  attr_accessor :user_id, :question_id, :parent_reply_id, :body

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
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id :user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = :user_id
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
  end

end
