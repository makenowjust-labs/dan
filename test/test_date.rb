module TestDan
  class Date < MTest::Unit::TestCase
    CONTEXT = Time.new(2017, 11, 16, 00, 00, 00)

    def parse(text, default_time = [0, 0, 0])
      Dan::Date.parse(text, default_time, CONTEXT)
    end

    def date(date)
      Time.new(
        date[:year] || CONTEXT.year,
        date[:month] || CONTEXT.month,
        date[:day] || CONTEXT.day,
        date[:hour] || 0,
        date[:min] || 0,
        date[:sec] || 0
      )
    end

    def test_parse
      assert_equal date(day: 1), parse('1'), 'day only'
      assert_equal date(month: 2, day: 23), parse('2/23'), 'month and day'
      assert_equal date(year: 2014, month: 12, day: 24), parse('2014/12/24'), 'year, month and day'
      assert_equal date(hour: 10, min: 3), parse('10:3'), 'hour and min'
      assert_equal date(hour: 10, min: 3, sec: 35), parse('10:3:35'), 'hour, min and sec'
    end
  end
end

MTest::Unit.new.run
