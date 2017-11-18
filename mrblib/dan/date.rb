module Dan
  module Date
    extend self

    DATETIME_REGEXP = %r{
      \A
      (?:(\d{4})[-/])?(?:(\d{1,2})[-/])?(\d{1,2})
      (?:[\ T](\d{1,2})(?::(\d{1,2})(?::(\d{1,2}))?)?)?
      \z
    }x
    TIME_REGEXP = %r{
      \A
      (\d{1,2})(?::(\d{1,2})(?::(\d{1,2}))?)?
      \z
    }x

    def parse(text, default_time = [0, 0, 0], context = Time.now)
      case text
      when 'today'
        # skip
      when DATETIME_REGEXP
        year = $1&.to_i 10
        month = $2&.to_i 10
        day = $3.to_i 10
        hour = $4&.to_i 10
        min = $5&.to_i 10
        sec = $6&.to_i 10
      when TIME_REGEXP
        hour = $1.to_i 10
        min = $2&.to_i 10
        sec = $3&.to_i 10
      else
        raise Error, "invalid date: #{text}"
      end

      year ||= context.year
      month ||= context.month
      day ||= context.day
      hour ||= default_time[0]
      min ||= default_time[1]
      sec ||= default_time[2]

      min, sec = min + sec / 60, sec % 60
      hour, min = hour + min / 60, min % 60
      day, hour = day + hour / 24, hour % 24

      begin
        Time.new(year, month, day, hour, min, sec)
      rescue
        raise Error, "invalid date: #{text}"
      end
    end

    def parse_range(text, context = Time.now)
      ts = text.split('..')

      case ts.size
      when 1
        t1 = parse(ts[0], [0, 0, 0], context)
        t2 = Time.new(t1.year, t1.month, t1.day, 23, 59, 59)
      when 2
        t1 = parse(ts[0], [0, 0, 0], context)
        t2 = parse(ts[1], [23, 59, 59], t1)
      else
        raise Error, "invalid date range: #{text}"
      end

      t1..t2
    end

    def format(t)
      "%04d-%02d-%02d %02d:%02d:%02d" % [
        t.year, t.month, t.day,
        t.hour, t.min, t.sec
      ]
    end
  end
end
