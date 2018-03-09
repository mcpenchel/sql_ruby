require_relative 'test'

class Task

	attr_reader :id
	attr_accessor :title, :description, :done

	def initialize(attributes = {})
		@id = attributes[:id]
		@title = attributes[:title]
		@description = attributes[:description]
		@done = attributes[:done]
	end

	def self.find(id)
		sql_statement = "SELECT * FROM tasks WHERE id = #{id}"
		result = DB.execute(sql_statement)
		return nil if result.empty?
		task_hash = result[0]

		Task.new(id: task_hash["id"],
						 title: task_hash["title"],
						 description: task_hash["description"],
						 done: task_hash["done"] == 0 ? false : true)
	end

	def self.all
		sql_statement = "SELECT * FROM tasks"
		result = DB.execute(sql_statement)
		
		if result.empty?
			result
		else
			tasks_array = []
			result.each do |task_hash|
				aux_hash = {}
				# tasks_hash.each do |key, value|
				# 	if key.to_s == "done"
				# 		aux_hash[key.to_s.to_sym] = value == 0 ? false : true
				# 	else
				# 		aux_hash[key.to_s.to_sym] = value
				# 	end
				# end

				# tasks_array << Task.new(aux_hash)
				tasks_array << Task.new(id: task_hash["id"],
																title: task_hash["title"],
																description: task_hash["description"],
																done: task_hash["done"] == 0 ? false : true)
			end
			tasks_array
		end
	end

	def destroy
		sql_statement = "DELETE FROM tasks WHERE id = #{id}"
		puts sql_statement
		DB.execute(sql_statement)
	end

	def save
		if @id
			sql_statement = "UPDATE tasks SET title = '#{title}', description = '#{description}', done = #{done ? 1 : 0} WHERE id = #{id}"
			DB.execute(sql_statement)
		else
			sql_statement = "INSERT INTO tasks (title, description, done) VALUES ('#{title}', '#{description}', #{done ? 1 : 0})"
			DB.execute(sql_statement)
			@id = DB.last_insert_row_id
		end
	end

end