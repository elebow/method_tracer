require 'where_is'

module MethodTracer
  class Tracer
    def initialize(target)
      @target_path = target

      @tracer = TracePoint.trace(:call) do |tp|
        record_call_if_interesting(tp)
      end
    end

    def record_call_if_interesting(tp)
      return unless class_is_interesting?(tp.defined_class)

      locations = caller_locations.select { |loc| loc.path.start_with?(Config.app_path) }
      return if locations.empty?

      outfile.write "#{@target_path} :#{tp.method_id}\n"
      locations.each do |loc|
        outfile.write "#{loc.path}:#{loc.lineno}\n"
      end
    end

    def outfile
      @outfile ||= begin
                     output_file = Config.output_file
                     if output_file.instance_of?(IO) || output_file.instance_of?(StringIO)
                       output_file
                     elsif output_file.instance_of?(String)
                       File.open(output_file, 'a')
                     else
                       raise "Unhandled output_file type: #{output_file}"
                     end
                   end
    end

    def class_is_interesting?(candidate_class)
      begin
        location = Where.is(candidate_class)
      rescue NameError
        return false
      end
      location[:file].start_with?(@target_path)
    end
  end
end
