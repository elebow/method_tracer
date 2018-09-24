# MethodTracer

MethodTracer is a tool for detecting lines in an application that call certain methods, somewhat akin to the syscall monitoring functionality of strace(1). The methods to be traced are specified by file pattern, which makes it simple to trace an entire gem<sup>1</sup>. The most common use case is helping developers and testers focus their efforts when upgrading or changing gems in large applications.

<sup>1</sup> Designating traced methods by file lets you trace methods defined in the "namespace" of a different gem. For example, if a hypothetical gem `activerecord-extension` defines some methods on the class `ActiveRecord`, we still have the ability to trace only the methods from `activerecord-extension` without capturing the methods from `activerecord`.

**Note about gem name**: due to a naming collision on rubygems.org, this gem appears there as `method_call_tracer`.

## Usage

To attach tracers to methods, instantiate `MethodTracer::Tracer` objects. For Rails applications, these can be placed in the provided initializer.

```ruby
# Trace all methods defined by the system installation of gibbon:
MethodTracer::Tracer.new('/var/lib/gems/2.3.0/gems/gibbon-2.2.4/')

# Trace all methods defined by rbenv's 2.3.3 installation of activerecord:
MethodTracer::Tracer.new('/home/eddie/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/activerecord-5.0.7/')
```

With tracers attached, exercise as much of the application as possible. Perhaps run the comprehensive test suite that you of course have.

## Configuration

MethodTracer supports the following configuration options:

`MethodTracer::Config.app_path`: The path of the application to trace calls from. MethodTracer will only report portions of call chains that are inside this path. Set it to `Rails.application.paths.path.to_s` for Rails applications. Set it to `'/'` or `''` to report all calls.

`MethodTracer::Config.output_file`: A filename or `IO` or `StringIO` object where the report output should be sent. Defaults to `$stdout`.

## Limitations

MethodTracer theoretically does not interfere with the original behavior of methods being traced. However, certain gems are known to misbehave when the tracing logic is monkeypatched in, and MethodTracer will refuse to trace those gems. Furthermore, any methods defined after the `MethodTracer::Tracer` is instantiated will remain untraced.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'method_call_tracer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install method_call_tracer

If you are using it with Rails, run the installation generator to install an example config initializer:

    $ rails generate method_tracer:install

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elebow/method_tracer.

## License
This gem is dedicated to the public domain. In jurisdictions where this is not possible, this gem is licensed to all under the least restrictive terms possible, and the author waives all waivable copyright rights.
