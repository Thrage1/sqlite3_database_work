
require 'SQLite3'
require_relative 'questions_database'

class User
  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |user| User.new(user)  }
  end
end
