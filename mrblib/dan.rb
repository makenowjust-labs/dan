def __main__(argv)
  begin
    Dan::App.new.parse(argv).run
    exit 0
  rescue OptionParser::ParseError => e
    puts "\e[31mERROR\e[0m: #{e.message}"
    exit 1
  rescue Dan::Error => e
    puts "\e[31mERROR\e[0m: #{e.message}"
    exit 1
  end
end
