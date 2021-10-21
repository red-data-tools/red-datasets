require "fileutils"
require "pathname"
require "time"
require "tmpdir"

require "datasets"

require "test-unit"

module Helper
  module Sandbox
    def setup_sandbox
      @tmp_dir = (Pathname.new(__dir__) + "tmp").expand_path
      FileUtils.mkdir_p(@tmp_dir)
    end

    def teardown_sandbox
      return unless defined?(@tmp_dir)
      FileUtils.rm_rf(@tmp_dir)
    end
  end

  module PathRestorable
    def restore_path(path)
      unless path.exist?
        return yield
      end

      Dir.mktmpdir do |dir|
        FileUtils.cp_r(path, dir, preserve: true)
        begin
          yield
        ensure
          FileUtils.rmtree(path, secure: true) if path.exist?
          FileUtils.cp_r(Pathname(dir) + path.basename,
                         path,
                         preserve: true)
        end
      end
    end
  end
end
