class RapidTransit::Action::Base

  attr_accessor :action_name, :key, :options, :condition, :block

  def initialize(action_name, *args, &block)
    @action_name = action_name
    options = args.extract_options!
    @condition = options.delete(:if)
    @options = options
    @key = args.first
    @block = block
    @validations = :action_name, :key
  end

  def result(row)
    receivers(row).zip(methods, params(row)).map { |r, m, p| r.send m, *p }.last
  end

  def valid?(actions)
    @validations.each { |v| send "validate_#{v}", actions }
  end

  def result_saved?
    # Override in your subclass if the action returns a saved active record
    false
  end

  def apply?(row)
    if condition.is_a? Hash
      result = condition.all? { |k, v| row[k] == v }
      result
    elsif condition.is_a? Proc
      condition.call(row)
    else
      true
    end
  end

private

  def receivers(row)
    # Override in your subclass
    [block]
  end

  def methods
    # Override in your subclass
    [:call]
  end

  def params(row)
    # Override in your subclass
    [[row]]
  end

  def validate_action_name(actions)
    validate_symbol(:action_name, action_name)
  end

  def validate_key(actions)
    validate_symbol(:key, key) if key
  end

  def validate_symbol(name, value)
    msg = "#{name} must be a Symbol"
    raise RapidTransit::ConfigError, msg, caller unless value.is_a? Symbol
  end

end
