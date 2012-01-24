class RapidTransit::Action::ClassMethod < RapidTransit::Action::Base

  attr_accessor :model, :attributes

  def initialize(action_name, model_name, *args)
    super
    @model = @key.to_s.classify.constantize
    @attributes = args.extract_options!.stringify_keys
    @key = args.first unless args.empty?
    @validations += [:model, :attributes]
  end

  def result_saved?
    ![:new, :find_or_initialize].include? action_name
  end

  def requires_attributes?
    action_name != :new
  end

private

  def receivers(row)
    [model]
  end

  def methods
    if [:find, :find_or_create, :find_or_initialize].include? action_name
      [action_name.to_s + "_by_" + attributes.keys.sort.join("_and_")]
    else
      [action_name]
    end
  end

  def params(row)
    if [:find, :find_or_create, :find_or_initialize].include? action_name
      [attributes.sort.map { |key, val| row[val] }]
    else
      array = attributes.map { |key, val| [key, row[val]] }
      [[Hash[array]]]
    end
  end

  def validate_action_name(actions)
    super
    methods = RapidTransit::AR_CLASS_METHODS
    msg = "The action must specify a method in: #{methods.inspect}"
    valid = methods.include? action_name
    raise RapidTransit::ConfigError, msg, caller unless valid
  end

  def validate_model(actions)
    msg = "No ActiveRecord model named #{model}"
    valid = model.ancestors.include? ActiveRecord::Base
    raise RapidTransit::ConfigError, msg, caller unless valid
  end

  def validate_attributes(actions)
    if requires_attributes? && attributes.empty?
      msg = "The attributes cannot be empty for a #{action_name} action"
      raise RapidTransit::ConfigError, msg, caller
    end
    attributes.each {|attribute| validate_attribute *attribute}
  end

  def validate_attribute(attribute, value)
    msg = "The #{model} model has no attribute named #{attribute}"
    valid = model.column_names.include? attribute
    raise RapidTransit::ConfigError, msg, caller unless valid
  end

end
