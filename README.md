# MethodTracer

MethodTracer is a tool for detecting lines in an application that call certain methods, somewhat akin to the syscall monitoring functionality of strace(1).

The most common use case is helping developers and testers focus their efforts when upgrading or changing gems in large applications.

MethodTracer's output is intended to be easily machine-readable.

**Note about gem name**: due to a naming collision on rubygems.org, this gem appears there as `method_call_tracer`.

## Usage

To attach tracers to methods, instantiate `MethodTracer::Tracer` objects and call `#enable`. For Rails applications, this can be done in the provided initializer.

The methods to be traced are specified by file pattern. You can optionally also specify a (partial) class name to speed up the matching process, which is recommended for performance. The comparison is a simple `String#include?`; no pattern matching is supported.

```ruby
# Trace all methods defined by the system installation of gibbon that also have "Gibbon" in the class name:
MethodTracer::Tracer.new(path: '/var/lib/gems/2.3.0/gems/gibbon-2.2.4/', name: 'Gibbon').enable

# Trace all methods defined by the system installation of gibbon, regardless of class name:
MethodTracer::Tracer.new(path: '/var/lib/gems/2.3.0/gems/gibbon-2.2.4/').enable

# Trace all methods defined by rbenv's 2.3.3 installation of activerecord, regardless of class name:
MethodTracer::Tracer.new(path: '/home/eddie/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/activerecord-5.0.7/').enable
```

With tracers attached, exercise as much of the application as possible. Perhaps run the comprehensive test suite that you of course have.

Using file paths makes it simple to trace an entire gem because it includes methods defined in the "namespace" of a different gem. For example, if a hypothetical gem `activerecord-extension` defines some methods on the class `ActiveRecord`, we still have the ability to trace only the methods from `activerecord-extension` without capturing the methods from `activerecord`.

## Configuration

MethodTracer supports the following configuration options:

`MethodTracer::Config.app_path`: The path of the application to trace calls from. MethodTracer will only report portions of call chains that are inside this path. Set it to `Rails.application.paths.path.to_s` for Rails applications. Set it to `'/'` or `''` to report all calls.

`MethodTracer::Config.output_file`: A filename or `IO` or `StringIO` object where the report output should be sent. Defaults to `$stdout`.

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
