module MethodTracer
  class Config
    class << self
      attr_accessor :app_path, :output_file
    end

    @output_file = $stdout
  end
end
