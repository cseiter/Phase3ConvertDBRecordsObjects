class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id=row[0]
    new_student.name=row[1]
    new_student.grade=row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql_all = <<-SQL
    select * from students;
    SQL
    DB[:conn].execute(sql_all).map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql_find_by_name = <<-SQL
    select * from students where name = ? limit 1
    SQL

    DB[:conn].execute(sql_find_by_name,name).map {|row| self.new_from_db(row)}.first

  end

  def self.all_students_in_grade_9
    sql_all_g_9 = <<-SQL
    select * from students where grade = 9;
    SQL
    DB[:conn].execute(sql_all_g_9).map {|row| self.new_from_db(row)}
  end  

  def self.students_below_12th_grade
    sql_all_below_12 = <<-SQL
    select * from students where grade <= 11;
    SQL
    DB[:conn].execute(sql_all_below_12).map {|row| self.new_from_db(row)}
  end  
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.first_X_students_in_grade_10(x)
    sql_first_x_in_10 = <<-SQL
    select * from students where grade = 10 order by students.id limit ?;
    SQL
    DB[:conn].execute(sql_first_x_in_10,x).map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql_first_in_10 = <<-SQL
    select * from students where grade = 10 order by students.id limit 1;
    SQL
    DB[:conn].execute(sql_first_in_10).map {|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_X(x)
    sql_all_in_x = <<-SQL
    select * from students where grade = ?;
    SQL
    DB[:conn].execute(sql_all_in_x,x).map {|row| self.new_from_db(row)}
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
