class RapidTransit::Row
  attr_accessor :values
  attr_accessor :parser
  attr_accessor :line
  attr_accessor :num

  def initialize(parser, line, num, delimiter = "\t")
    @parser = parser
    @line = line
    @num = num
    @values = extract_columns delimiter
  end

  def parse
    parser.actions.each do |action|
      apply action
    end
  end

  def apply(action)
    return unless action.apply? self
    self.values[action.key] = action.result(self)
    check_result(action)
  end

  def [](arg)
    if arg.is_a? Hash
      key, method = arg.first
      @values[key].send method
    else
      @values[arg]
    end
  end

  def []=(key, val)
    @values[key] = val
  end

private

  def check_result(action)
    unless !action.result_saved? || values[action.key] && values[action.key].id
      record = values[action.key]
      errors = record ? record.errors.full_messages.join("\n") : "Not found"
      message = "Error parsing #{action.key} on line #{num}: #{errors}\n\n" +
                parser.column_names.map {|c| "#{c}: #{values[c]}"}.join("\n")
      raise RapidTransit::NotFoundError, message, caller
    end
  end

  def extract_columns(delimiter)
    columns = line.split(delimiter)
    unless columns.count == parser.column_names.count
      message = "Wrong number of columns in line #{num}:\n#{line}\n" +
                "(Expected columns: #{parser.column_names.join(", ")})"
      raise RapidTransit::ColumnMismatchError, message, caller
    end
    array = parser.column_names.zip(columns).map { |key, value| [key, value] }
    Hash[array]
  end

end
