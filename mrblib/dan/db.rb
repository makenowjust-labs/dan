module Dan
  module DB
    extend self

    def open
      db = SQLite3::Database.open("#{Dan::Env.data}/logs.db")
      begin
        setup db
        yield db
      ensure
        db.close
      end
    end

    def setup(db)
      # create 'logs' table
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS logs (
          id    INTEGER PRIMARY KEY,
          title TEXT,
          body  TEXT,
          date  DATETIME
        )
      SQL

      # create 'logs_date' index
      db.execute <<-SQL
        CREATE INDEX IF NOT EXISTS logs_dare ON logs (date)
      SQL
    end
  end
end
