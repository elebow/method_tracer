module MethodTracer
  class Tracer
    UNCOOPERATIVE_NAMES = [
      # Some classes don't behave well when we try to hook them, at least with
      # the methods currently used.
      'CGI',    # Waits for input from stdin when opening rails console
      'RSpec'   # RSpec doesn't run
    ].freeze

    def initialize(target)
      @target_path = target

      find_methods!

      add_hooks_to_class_methods
      add_hooks_to_instance_methods
    end

    def self.uncooperative_class?(class_name)
      !class_name.nil? &&
        UNCOOPERATIVE_NAMES.any? { |bad_name| class_name.include?(bad_name) }
    end

    def self.record_and_call_original(unbound_m, receiver, *args, &block)
      outfile.write "#{receiver}.#{unbound_m.name} called from:\n"
      caller_locations.select { |loc| loc.path.start_with?(Config.app_path) }
                      .each do |loc|
                        outfile.write "#{loc.path}:#{loc.lineno}\n"
                      end

      unbound_m.bind(receiver).call(*args, &block)
    end

    def self.outfile
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

    private

    def add_hooks_to_class_methods
      methods_of_interest(@all_class_methods).each do |m|
        unbound_m = m.unbind
        receiver = m.receiver

        receiver.send(:define_singleton_method, unbound_m.name) do |*args, &block|
          Tracer.record_and_call_original(unbound_m, receiver, *args, &block)
        end
      end
    end

    def add_hooks_to_instance_methods
      methods_of_interest(@all_instance_methods).each do |m|
        unbound_m = m.unbind
        receiver = m.receiver

        receiver.class.send(:define_method, m.name) do |*args, &block|
          Tracer.record_and_call_original(unbound_m, receiver, *args, &block)
        end
      end
    end

    def find_methods!
      @all_class_methods = []
      @all_instance_methods = []
      ObjectSpace.each_object(Class) do |defined_class|
        next if Tracer.uncooperative_class?(defined_class.name)

        defined_class.methods(false).each do |method_sym|
          @all_class_methods << defined_class.method(method_sym)
        end

        begin
          instance = defined_class.new
          defined_class.instance_methods(false).each do |method_sym|
            @all_instance_methods << instance.method(method_sym)
          end
        rescue StandardError, NotImplementedError, LoadError
          # If the class isn't instantiable, skip it
          next
        end
      end
    end

    def methods_of_interest(methods)
      methods.select do |m|
        m.instance_of?(Method) &&
          !m.source_location.nil? &&
          m.source_location[0].start_with?(@target_path)
      end
    end
  end
end
