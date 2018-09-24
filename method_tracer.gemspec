lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'method_tracer/version'

Gem::Specification.new do |spec|
  spec.name          = 'method_tracer'
  spec.version       = MethodTracer::VERSION
  spec.authors       = ['Eddie Lebow']
  spec.email         = ['elebow@users.noreply.github.com']

  spec.summary       = 'A tool that finds lines in your application that call a specified method'
  spec.description   = 'This tool wraps every specified method with some logging statements ' \
                       'that record the call stack, allowing you to see exactly which lines in ' \
                       'your application make calls to methods in question. The specified ' \
                       'methods can constitute all methods defined in a certain gem.'
  spec.homepage      = 'https://github.com/elebow/method_tracer'
  spec.license       = 'public domain'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest', '~> 0'
end
