require 'test_helper'
require 'fixtures/my-app/app'

class MethodTracerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MethodTracer::VERSION
  end

  def test_method_tracing
    test_base_dir = __dir__
    MethodTracer::Config.app_path = test_base_dir + '/fixtures/my-app'
    MethodTracer::Config.output_file = StringIO.new
    MethodTracer::Tracer.new(path: test_base_dir + '/fixtures/my-great-gem').enable

    App.new.run_instance_method
    App.new.run_class_method

    report_lines = MethodTracer::Config.output_file.string
    expected_lines = %r{
      MyGreatGem\ :great_instance_method\n
      #{Regexp.quote(test_base_dir)}/fixtures/my-app/app.rb:5\n
      \#<Class:MyGreatGem>\ :great_class_method\n
      #{Regexp.quote(test_base_dir)}/fixtures/my-app/app.rb:9\n
    }x
    assert expected_lines.match(report_lines)

    # assert the original methods were executed
    assert_equal MyGreatGem.instance_variable_get(:@instance_method_executed), 'great!'
    assert_equal MyGreatGem.instance_variable_get(:@class_method_executed), 'great!!!!!!!'
  end

  def test_short_circuit_on_class_name
    tracer = MethodTracer::Tracer.new(path: "#{__dir__}/fixtures/my-great-gem", name: 'OtherGem')

    # We want to assert that the short circuit is taken, so make a later method raise an exception
    tracer.define_singleton_method(:method_is_defined_in_target_path, proc { raise })

    assert !tracer.method_is_interesting?(MyGreatGem, :great_method)
  end
end
