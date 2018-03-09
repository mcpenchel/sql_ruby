require 'sqlite3'
require 'byebug'
# require_relative 'task'

db_file_path = "tasks.db"
DB = SQLite3::Database.new(db_file_path)
DB.results_as_hash = true