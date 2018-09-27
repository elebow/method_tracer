require 'where_is'

module MethodTracer
  class Tracer
    def initialize(path:, name: nil)
      @target_path = path
      @target_name = name
    end

    def enable
      @tracer = TracePoint.trace(:call) do |tp|
        record_call_if_interesting(tp)
      end
    end

    def record_call_if_interesting(tp)
      return unless method_is_interesting?(tp.defined_class, tp.method_id)

      locations = caller_locations.select { |loc| loc.path.start_with?(Config.app_path) }
      return if locations.empty?

      outfile.write "#{tp.defined_class} :#{tp.method_id} "
      outfile.write locations.map { |loc| "#{loc.path}:#{loc.lineno}" }.join('; ')
      outfile.write "\n"
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

    def method_is_interesting?(candidate_class, method_id)
      candidate_name = if candidate_class.instance_of?(Class)
                         candidate_class.name
                       else
                         candidate_class.class.name
                       end

      # short circuit if possible for speed
      return false if !@target_name.nil? &&
                      !candidate_name.nil? &&
                      !candidate_name.include?(@target_name)

      method_is_defined_in_target_path(candidate_class, method_id)
    end

    def method_is_defined_in_target_path(candidate_class, method_id)
      begin
        location = Where.is(candidate_class, method_id)
      rescue NameError
        return false
      end

      location[:file].start_with?(@target_path)
    end
  end
end
