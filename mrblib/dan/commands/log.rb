module Dan
  module Commands
    class Log
      def initialize
        @long = false
        @date = true
        @order = 'DESC'

        @done = false
      end

      DATE_RANGE_SELECT = <<-SQL
        SELECT
          title, body, date
        FROM logs
        WHERE
          date BETWEEN ? AND ?
        ORDER BY date
      SQL

      def run
        return if @done

        preview do |out|
          DB.open do |db|
            @date_ranges.each do |r|
              b, e = Date.format(r.begin), Date.format(r.end)

              last_date = nil
              db.execute "#{DATE_RANGE_SELECT} #{@order}", [b, e] do |row|
                title, body, date = row

                if @long
                  out << "\e[1m##\e[0m "
                  out << "\e[33;4m(#{date[0..-4]})\e[0m " if @date
                  out << "\e[1m#{title}\e[0m"
                  out.puts

                  unless body.empty?
                    out.puts
                    out.puts body
                  end

                  out.puts
                else
                  date, time = date.split(' ')

                  if last_date != date
                    if @date
                      out.puts if last_date
                      out.puts "\e[34;4m#{date}\e[0m"
                    end
                  end
                  last_date = date

                  time = time[0..-4] # drop second

                  out << "  \e[33m#{time}\e[0m " if @date
                  out << "\e[1m#{title}\e[0m"
                  unless body.empty?
                    out << " \e[30;47m...\e[0m"
                  end
                  out.puts
                end
              end
            end
          end
        end
      end

      def preview
        if STDOUT.tty?
          Tempfile.open('dan-preview') do |f|
            yield f
            system("#{Env.pager} #{Shellwords.escape f.path}")
          end
        else
          yield STDOUT
        end
      end

      def parse(argv)
        argv = opt.parse(argv)
        argv = ['today'] if argv.empty?
        @date_ranges = argv.map { |x| Date.parse_range x }

        self
      end

      def opt
        @opt ||= OptionParser.new do |opt|
          opt.banner = ~<<-BANNER
            dan log - show commit logs

            Usage: dan log [-l] [-D] [-r] [date-range ...]

            Options:
          BANNER

          opt.on('-l', '--long', 'enable long output') do
            @long = true
          end

          opt.on('-D', '--no-date', "suppress date output") do
            @date = false
          end

          opt.on('-r', '--reverse', 'reverse output') do
            @order = 'ASC'
          end

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
