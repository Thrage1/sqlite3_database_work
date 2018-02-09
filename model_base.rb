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
      data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{table}
    SQL
    data.map { |datum| self.new(datum) }
  end

  def save
  end

  def self.where(options)
    if options.is_a?(Hash)
      vals = options.values
      where = options.keys.map { |key| "#{key} = ?" }.join(" AND ")
    else
      vals = []
    end
    data = QuestionsDatabase.instance.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table}
      WHERE
        #{where}
    SQL
  end
end
# you can use Object#instance_variables
