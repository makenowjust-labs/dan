module Dan
  module Util
    extend self

    def mkdir_p(dir)
      dir = Shellwords.escape(dir)
      `mkdir -p #{dir}`
    end

    def rm(file)
      file = Shellwords.escape(file)
      `rm #{file}`
    end

    def touch(file)
      file = Shellwords.escape(file)
      `touch #{file}`
    end
  end
end
