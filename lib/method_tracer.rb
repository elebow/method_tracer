require 'method_tracer/tracer'

require 'method_tracer/version'

module MethodTracer
  class Config
    class << self
      attr_accessor :app_path, :output_file
    end

    @output_file = $stdout
  end
end
