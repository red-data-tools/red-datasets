module Datasets
  class CachePath
    def initialize(id)
      @id = id
    end

    def base_dir
      Pathname(system_cache_dir).expand_path + 'red-datasets' + @id
    end

    def remove
      FileUtils.rmtree(base_dir.to_s, secure: true) if base_dir.exist?
    end

    private

    def system_cache_dir
      case RUBY_PLATFORM
      when /mswin/, /mingw/
        ENV['LOCALAPPDATA'] || '~/AppData/Local'
      when /darwin/
        '~/Library/Caches'
      else
        ENV['XDG_CACHE_HOME'] || '~/.cache'
      end
    end
  end
end
