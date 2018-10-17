lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'method_tracer/version'

Gem::Specification.new do |spec|
  spec.name          = 'method_call_tracer'
  spec.version       = MethodTracer::VERSION
  spec.authors       = ['Eddie Lebow']
  spec.email         = ['elebow@users.noreply.github.com']

  spec.summary       = 'A tool that finds lines in your application that call a specified method(s)'
  spec.description   = 'This tool reports which lines in your application call (directly or ' \
                       'indirectly) a method matching a pattern you specify. Lets you find out ' \
                       'which lines in your application are dependent on a given gem, among ' \
                       'other things.'
  spec.homepage      = 'https://github.com/elebow/method_tracer'
  spec.license       = 'public domain'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'where_is', '~> 0'

  spec.add_development_dependency 'minitest', '~> 5'
end
