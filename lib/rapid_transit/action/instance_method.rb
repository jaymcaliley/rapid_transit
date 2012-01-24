class RapidTransit::Action::InstanceMethod < RapidTransit::Action::Base

  attr_accessor :attributes

  def initialize(action_name, *args)
    super
    @attributes = @options
    @validations += [:attributes]
  end

  def result_saved?
    ![:destroy].include? action_name
  end

  def requires_attributes?
    ![:save, :destroy].include? action_name
  end

  def requires_no_attributes?
    [:save, :destroy].include? action_name
  end

private

  def receivers(row)
    result_saved? ? [row[key], row] : [row[key]]
  end

  def methods
    result_saved? ? [action_name, :[]] : [action_name]
  end

  def params(row)
    result_saved? ? [[hash_params(row)], [key]] : [[hash_params(row)]]
  end

  def hash_params(row)
    array = attributes.map do |key, val|
      [key, row[val]]
    end
    Hash[array]
  end

  def validate_action_name(actions)
    super
    methods = RapidTransit::AR_INSTANCE_METHODS
    msg = "The action must specify a method in: #{methods.inspect}"
    valid = methods.include? action_name
    raise RapidTransit::ConfigError, msg, caller unless valid
  end

  def validate_attributes(actions)
    if requires_attributes? && attributes.empty?
      msg = "The attributes cannot be empty for a #{action_name} action"
      raise RapidTransit::ConfigError, msg, caller
    elsif requires_no_attributes? && !attributes.empty?
      msg = "The attributes must be empty for a #{action_name} action"
      raise RapidTransit::ConfigError, msg, caller
    end
    attributes.each {|attribute| validate_attribute actions, *attribute}
  end

  def validate_attribute(actions, key, value)
    msg = "The #{model(actions)} model has no attribute named #{key}"
    valid = model(actions).column_names.include? key.to_s
    raise RapidTransit::ConfigError, msg, caller unless valid
  end

  def validate_key(actions)
    msg = "The #{action_name} method must reference a previously defined record"
    valid = actions.keys.include? key
    raise RapidTransit::ConfigError, msg, caller unless valid
  end

  def model(actions)
    actions.select do |action|
      action.is_a?(RapidTransit::Action::ClassMethod) && action.key == key
    end.first.model
  end
end
