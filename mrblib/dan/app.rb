module Dan
  class App
    attr_reader :commands

    def initialize
      @commands = {
        'commit' => Dan::Commands::Commit.new,
        'log' => Dan::Commands::Log.new,
        'help' => Dan::Commands::Help.new(self),
        'version' => Dan::Commands::Version.new,
      }

      @done = false
    end

    def run
      return if @done

      if @commands.has_key? @command
        @commands[@command].parse(@argv).run
        return
      else
        raise Error, "invalid command: #{@command}"
      end
    end

    def parse(argv)
      argv.shift # drop $PROGRAM_NAME
      opt.order argv

      @command ||= argv.shift || 'help'
      @argv = argv

      self # for method chaining
    end

    def opt
      @opt ||= OptionParser.new do |opt|
        opt.banner = ~<<-BANNER
          dan - done activity recorder

          Usage: dan <command>

          Command:
              commit                           record done activity
              log                              show commit logs
              help                             display help information
              version                          display version

          Options:
        BANNER

        opt.on('-h [command]', '--help', 'display help information') do |command|
          next if @done
          @commands['help'].parse([command]).run
          @done = true
        end

        opt.on('-v', '--version', 'display version') do
          next if @done
          @commands['version'].parse([]).run
          @done = true
        end
      end
    end

    alias help opt

    def show_help(command)
      @command['help'].parse([command]).run
    end
  end
end
