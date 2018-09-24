module MethodTracer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.dirname(__FILE__) + '/templates'
      desc 'Installs initializer'

      def install
        template 'initializer.rb', 'config/initializers/method_tracer.rb'
      end
    end
  end
end
