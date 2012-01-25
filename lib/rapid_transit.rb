module RapidTransit
  class ConfigError < StandardError; end
  class NoFileError < StandardError; end
  class ColumnMismatchError < StandardError; end
  class NotFoundError < StandardError; end
  AR_CLASS_METHODS = :new, :find, :find_or_initialize, :find_or_create, :create
  AR_INSTANCE_METHODS = :update_attributes, :save, :destroy
end

require 'rapid_transit/action'
require 'rapid_transit/action_list'
require 'rapid_transit/row'
require 'rapid_transit/base'
