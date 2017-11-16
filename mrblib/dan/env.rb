module Dan
  module Env
    extend self

    def data
      unless @data
        if xdg_data_home = ENV['XDG_DATA_HOME']
          @data = "#{xdg_data_home}/dan"
        elsif home = ENV['HOME']
          @data = "#{home}/.local/share/dan"
        else
          @data = "#{Dir.pwd}/.dan"
        end

        Dan::Util.mkdir_p(@data) unless File.directory? @data
      end

      @data
    end

    def cache
      unless @cache
        if xdg_cache_home = ENV['XDG_CACHE_HOME']
          @cache = "#{xdg_cache_home}/dan"
        elsif home = ENV['HOME']
          @cache = "#{home}/.cache/dan"
        else
          @cache = "#{Dir.pwd}/.dan"
        end

        Dan::Util.mkdir_p(@cache) unless File.directory? @cache
      end

      @cache
    end

    def editor
      ENV['EDITOR'] || 'vim'
    end

    def pager
      ENV['PAGER'] || 'less -X -F -R'
    end
  end
end
