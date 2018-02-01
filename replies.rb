
require 'SQLite3'
require_relative 'questions_database'

class Reply
  attr_accessor :user_id, :question_id, :parent_reply_id, :body

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
  end

end
