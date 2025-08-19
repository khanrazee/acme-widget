require 'logger'

# Patch for Ruby 3.1.2 and Rails 7.0.x compatibility issue
module ActiveSupport
  module LoggerThreadSafeLevel
    def local_level
      @local_level
    end

    def local_level=(level)
      @local_level = level
    end

    def after_initialize
      @local_level = level
    end
  end
end
