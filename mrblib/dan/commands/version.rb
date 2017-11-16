module Dan
  module Commands
    class Version
      def initialize
        @done = false
      end

      def run
        return if @done
        puts "dan version #{Dan::VERSION}"
      end

      def parse(argv)
        opt.parse argv

        self
      end

      def opt
        @opt ||= OptionParser.new do |opt|
          opt.banner = ~<<-BANNER
            dan version - display version

            Usage: dan version

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
