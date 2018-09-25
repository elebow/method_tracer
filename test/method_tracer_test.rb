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
    MethodTracer::Tracer.new(test_base_dir + '/fixtures/my-great-gem')

    App.new.run_instance_method
    App.new.run_class_method

    report_lines = MethodTracer::Config.output_file.string
    expected_lines = %r{
      #{Regexp.quote(test_base_dir)}/fixtures/my-great-gem\ :great_instance_method\n
      #{Regexp.quote(test_base_dir)}/fixtures/my-app/app.rb:5\n
      #{Regexp.quote(test_base_dir)}/fixtures/my-great-gem\ :great_class_method\n
      #{Regexp.quote(test_base_dir)}/fixtures/my-app/app.rb:9\n
    }x
    assert expected_lines.match(report_lines)

    # assert the original methods were executed
    assert_equal MyGreatGem.instance_variable_get(:@instance_method_executed), 'great!'
    assert_equal MyGreatGem.instance_variable_get(:@class_method_executed), 'great!!!!!!!'
  end
end
