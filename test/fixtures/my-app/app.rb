require 'fixtures/my-great-gem/gem'

class App
  def run_instance_method
    MyGreatGem.new.great_instance_method
  end

  def run_class_method
    MyGreatGem.great_class_method
  end
end
