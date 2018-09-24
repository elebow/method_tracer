class MyGreatGem
  @instance_method_executed = false
  @class_method_executed = false

  def great_instance_method
    MyGreatGem.instance_variable_set(:@instance_method_executed, 'great!')
  end

  def self.great_class_method
    MyGreatGem.instance_variable_set(:@class_method_executed, 'great!!!!!!!')
  end
end
