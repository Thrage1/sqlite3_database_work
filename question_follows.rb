
require 'SQLite3'
require_relative 'questions_database'

class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |question_follow| QuestionFollow.new(question_follow) }
  end

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end
