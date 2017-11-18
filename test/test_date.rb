module TestDan
  class Date < MTest::Unit::TestCase
    CONTEXT = Time.new(2017, 11, 16, 00, 00, 00)

    def parse(text, default_time = [0, 0, 0])
      Dan::Date.parse(text, default_time, CONTEXT)
    end

    def parse_range(text)
      Dan::Date.parse_range(text, CONTEXT)
    end

    def date(date = {})
      Time.new(
        date[:year] || CONTEXT.year,
        date[:month] || CONTEXT.month,
        date[:day] || CONTEXT.day,
        date[:hour] || 0,
        date[:min] || 0,
        date[:sec] || 0
      )
    end

    def end_date(date = {})
      Time.new(
        date[:year] || CONTEXT.year,
        date[:month] || CONTEXT.month,
        date[:day] || CONTEXT.day,
        date[:hour] || 23,
        date[:min] || 59,
        date[:sec] || 59
      )
    end

    def test_parse
      assert_equal date(), parse('today'), 'today'

      assert_equal date(day: 1), parse('1'), 'day only'
      assert_equal date(month: 2, day: 23), parse('2/23'), 'month and day'
      assert_equal date(year: 2014, month: 12, day: 24), parse('2014/12/24'), 'year, month and day'

      assert_equal date(hour: 10, min: 3), parse('10:3'), 'hour and min'
      assert_equal date(hour: 10, min: 3, sec: 35), parse('10:3:35'), 'hour, min and sec'

      assert_equal(
        date(year: 2014, month: 12, day: 24, hour: 10, min: 3, sec: 35),
        parse('2014/12/24 10:03:35'),
        'full'
      )
    end

    def test_parse_range
      assert_equal date()..end_date(), parse_range('today'), 'today'

      assert_equal date(day: 1)..end_date(day: 1), parse_range('1'), 'single'
      assert_equal date(month: 2, day: 23)..end_date(month: 2, day: 25), parse_range('2/23..25'), 'begin and end'
    end
  end
end

MTest::Unit.new.run
