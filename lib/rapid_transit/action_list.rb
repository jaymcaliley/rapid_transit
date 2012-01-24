class RapidTransit::ActionList
  include Enumerable

  attr_accessor :columns, :actions

  def initialize(columns = [])
    @actions = []
    @columns = columns
  end

  def add(action)
    @actions << action if action.valid?(self)
  end

  def each
    @actions.each { |a| yield a }
  end

  def keys
    columns + @actions.map { |a| a.key }
  end

end
