require "fileutils"
require "pathname"

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
end
