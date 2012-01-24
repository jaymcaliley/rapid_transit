class RapidTransit::Base

  # Define singleton for class variables whose values will not be inherited by
  # subclasses of RapidTransit::Base
  class << self
    attr_accessor :column_names, :actions
  end

  # Define the list of columns expected in the CSV file
  def self.columns(*list)
    msg = 'Columns must be passed as Symbols'
    raise ArgumentError, msg, caller unless list.all? { |i| i.is_a? Symbol }
    msg = 'Column names must be unique'
    raise ArgumentError, msg, caller unless list.uniq == list
    @column_names = list
  end

  def self.define_action(action_class, method)
    class_eval <<-EOS
      def self.#{method}(key, *args, &block)
        self.actions.add #{action_class}.new(:#{method}, key, *args, &block)
      end
    EOS
  end

  # Create methods for manipulating ActiveRecord classes
  RapidTransit::AR_CLASS_METHODS.each do |method|
    define_action RapidTransit::Action::ClassMethod, method
  end

  # Create methods for manipulating ActiveRecord instances
  RapidTransit::AR_INSTANCE_METHODS.each do |method|
    define_action RapidTransit::Action::InstanceMethod, method
  end

  # Define the setter method for setting a value in the row hash
  #define_action RapidTransit::Action::Setter, :set
  def self.set(key, &block)
    self.actions.add RapidTransit::Action::Setter.new(:set, key, &block)
  end


  # Define the setter method for setting a value in the row hash
  def self.exec(*args, &block)
    self.actions.add RapidTransit::Action::Base.new(:module_exec, *args, &block)
  end

  # Get the actions list
  def self.actions
    @actions ||= RapidTransit::ActionList.new
  end

  # Parse a CSV file
  def self.parse(file)
    raise RapidTransit::NoFileError, "File is blank", caller if file.blank?
    before_parse
    count = file.inject(0) do |sum, line|
      RapidTransit::Row.new(self, line, sum + 1).parse
      sum + 1
    end
    after_parse
    count
  end

  # Callback executed before parsing the file
  def self.before_parse; end

  # Callback executed after parsing the file
  def self.after_parse; end

end
