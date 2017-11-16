module Dan
  module Commands
    class Help
      def initialize(app)
        @done = false
        @app = app
      end

      def run
        return if @done

        if @command
          if @app.commands.has_key? @command
            puts @app.commands[@command].help
          else
            raise Error, "invalid command: #{@command}"
          end
        else
          puts @app.help
        end
      end

      def parse(argv)
        argv = opt.parse argv
        @command = argv.shift unless @done

        self
      end

      def opt
        @opt ||= OptionParser.new do |opt|
          opt.banner = ~<<-BANNER
            dan help - display help information

            Usage: dan help [command]

            Options:
          BANNER

          opt.on('-h', '--help', 'display help information') do
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
