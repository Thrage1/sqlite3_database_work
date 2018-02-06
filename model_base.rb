require 'SQLite3'
require_relative 'questions_database'

class ModelBase

  def self.table
    self.to_s.downcase + 's'
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = :id
    SQL
    self.new(data.first)
  end

  def self.all
  end

  def save
  end
end
# you can use Object#instance_variables
