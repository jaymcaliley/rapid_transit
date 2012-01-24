class RapidTransit::Action::Setter < RapidTransit::Action::Base

private

  def receivers(row)
    [row]
  end

  def methods
    [:[]=]
  end

  def params(row)
    [[key, block.call(row)]]
  end

  def validate_action_name(actions)
    super
    methods = RapidTransit::AR_CLASS_METHODS +
              RapidTransit::AR_INSTANCE_METHODS +
              [:set]
    msg = "The action must specify a method in: #{methods.inspect}"
    valid = methods.include? action_name
    raise RapidTransit::ConfigError, msg, caller unless valid
  end

end
