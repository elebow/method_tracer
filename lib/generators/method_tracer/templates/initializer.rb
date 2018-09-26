require 'method_tracer'

# Define the prefix for the application code. Only calls matching this pattern
# will be recorded.
MethodTracer::Config.app_path = Rails.application.paths.path.to_s

# Override the default output file. Specify a filename string or an IO or StringIO object
# like `$stdout`.
# MethodTracer::Config.output_file = 'output_file_2.log'

# Create a MethodTracer::Tracer object for every gem to be spied on
# MethodTracer::Tracer.new(path: '/var/lib/gems/2.3.0/gems/gibbon-2.2.4/', name: 'Gibbon').enable
# MethodTracer::Tracer.new(path: '/var/lib/gems/2.3.0/gems/other_gem-1.0.0/').enable
