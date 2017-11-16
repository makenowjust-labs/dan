module Dan
  module Commands
    class Commit
      def initialize
        @message = nil

        @done = false
      end

      def run
        return if @done

        unless @message
          message_file = "#{Dan::Env.cache}/COMMIT_MESSAGE"
          Dan::Util.touch message_file
          system("#{Dan::Env.editor} #{Shellwords.escape message_file}")
          @message = File.read(message_file)
          Dan::Util.rm message_file
        end

        @message = @message.strip
        raise Error, "empty message" if @message.empty?

        lines = @message.lines
        title = lines.shift.strip
        body = lines.join.strip

        DB.open do |db|
          db.execute <<-SQL, [title, body]
            INSERT INTO logs (title, body, date) VALUES (?, ?, datetime('now', 'localtime'))
          SQL

          title, body, date = db.execute(<<-SQL).last
            SELECT title, body, date FROM logs WHERE id = (SELECT MAX(id) FROM logs)
          SQL

          puts ~<<-RESULT
            \e[1mtitle\e[0m: #{title}
            \e[1mdate\e[0m : #{date}
          RESULT
          unless body.empty?
            puts
            puts body
          end
        end
      end

      def parse(argv)
        argv = opt.parse argv

        self
      end

      def opt
        @opt ||= OptionParser.new do |opt|
          opt.banner = ~<<-BANNER
            dan commit - record done activity log

            Usage; dan commit [-m <message>] [--date=<date>]

            Options:
          BANNER

          opt.on('-m message', '--message', 'use given message') do |msg|
            @message = msg
          end

          opt.on('-h', '--help') do
            next if @done
            puts opt
            @done = true
          end
        end
      end

      alias help opt
    end
  end
end
