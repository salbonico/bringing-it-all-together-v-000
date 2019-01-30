class Dog
attr_accessor :name, :breed
attr_reader :id

def initialize(id:nil,name:,breed:)
@id = id
@name = name
@breed = breed
end

def self.create_table
sql = <<-SQL
CREATE TABLE IF NOT EXISTS dogs(
  id INTEGER primary key,
  name TEXT,
  breed TEXT
);
SQL
DB[:conn].execute(sql)
end

def self.drop_table
DB[:conn].execute("DROP TABLE dogs")
end

def save
sql = <<-SQL
INSERT INTO dogs (name,breed)
VALUES (?,?);
SQL
DB[:conn].execute(sql,@name,@breed)
@id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
self
end

def self.create(input)
new_dog = self.new(input)
new_dog.save
new_dog
end

def self.find_by_id(id)
sql = <<-SQL
SELECT *
FROM dogs
WHERE id = ?;
SQL
end

end
