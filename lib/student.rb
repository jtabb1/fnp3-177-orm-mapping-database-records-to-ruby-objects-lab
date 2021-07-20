class Student
  attr_accessor :id, :name, :grade

  # This original method, along with the "self.new_from_db_0" 
  #  method below (both with the "_0"'s taken out), passed the tests:
  def initialize_0(name: nil, grade: nil, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  # This original method, along with the "initialize_0" 
  #  method above (both with the "_0"'s taken out), passed the tests:
  def self.new_from_db_0(row)
    self.new(id: row[0], name: row[1], grade: row[2])
  end

  # The method from the official solution below also works:
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all_students_in_grade_X(xArg)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? 
      ORDER BY students.id
    SQL
    DB[:conn].execute(sql, xArg).map do |rw|
      self.new_from_db(rw)
    end
  end
  
  def self.first_X_students_in_grade_10(xArg)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 
      ORDER BY students.id LIMIT ?
    SQL
    DB[:conn].execute(sql, xArg).map do |rw|
      self.new_from_db(rw)
    end
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 
      ORDER BY students.id LIMIT 1
    SQL
    DB[:conn].execute(sql).map do |rw|
      self.new_from_db(rw)
    end.first
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    DB[:conn].execute(sql).map do |rw|
      self.new_from_db(rw)
    end
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL
    DB[:conn].execute(sql).map do |rw|
      self.new_from_db(rw)
    end
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
      LIMIT 1 
    SQL
    DB[:conn].execute(sql, name).map do |rw|
      self.new_from_db(rw)
    end.first
  end
  
  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    DB[:conn].execute(sql).map do |rw| 
      self.new_from_db(rw)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
