require 'spec_helper'

describe RapidTransit::Base do
  it "returns default delimiter if not set explicitly" do
    RapidTransit::Base.delimiter.should eq ","
  end

  it "sets the delimeter" do
    RapidTransit::Base.delimit("|")
    RapidTransit::Base.delimiter.should eq "|"
  end

  it "returns true for strip if not set" do
    RapidTransit::Base.strip.should be true
  end

  it "sets the strip class var" do
    RapidTransit::Base.strip_columns(false)
    RapidTransit::Base.strip.should eq false
    RapidTransit::Base.strip_columns(true)
    RapidTransit::Base.strip.should be true
  end

  it "sets the error handler on_error" do
    RapidTransit::Base.error_handler.parameters.should eq [[:opt, :error], [:opt, :row]]
  end

  it "raises argerror on_error without block" do
    expect { RapidTransit::Base.on_error }.should raise_error
  end

  it "raises argerror on_error if block arity is not 2" do
    expect { RapidTransit::Base.on_error {|test| puts "test" }}.should raise_error
  end

  it "does not raise error on_error if block arity is 2" do
    expect { RapidTransit::Base.on_error {|test, test2| puts "test" }}.should_not raise_error
  end

  it "raises error if columns are not symbols" do
    expect { RapidTransit::Base.colums(:test, :test2, :test3) }.should raise_error
  end

  it "raises error if column names are not unique" do
    expect { RapidTransit::Base.colums(:test, :test) }.should raise_error
  end

  it "sets the column names" do
    RapidTransit::Base.columns(:test, :test2, :test3)
    RapidTransit::Base.column_names.should eq [:test, :test2, :test3]
  end

  it "defines an action" do
    RapidTransit::Base.define_action("TestClass","test_method")
    defined?(RapidTransit::Base.test_method).should eq "method"
  end

  it "creates AR class methods for RT Base" do
    defined?(RapidTransit::Base.new).should eq "method"
    defined?(RapidTransit::Base.find).should eq "method"
    defined?(RapidTransit::Base.find_or_initialize).should eq "method"
    defined?(RapidTransit::Base.find_or_create).should eq "method"
    defined?(RapidTransit::Base.create).should eq "method"
  end

  it "creates AR instance methods for RT Base" do
    defined?(RapidTransit::Base.update_attributes).should eq "method"
    defined?(RapidTransit::Base.save).should eq "method"
    defined?(RapidTransit::Base.destroy).should eq "method"
  end

  it "defines setter method for setting value in row hash" do
    RapidTransit::Base.set(:test){ |test| puts "test" }
    RapidTransit::Base.actions.actions[0].key.should eq :test
  end

  it "adds actions using exec" do
    RapidTransit::Base.exec do |row|
      test = "test"
    end
    RapidTransit::Base.actions.actions.size.should eq 2
    RapidTransit::Base.actions.actions[1].action_name.should eq :module_exec
  end

  it "returns blank actionlist if no actions have been set" do
    RapidTransit::Base.actions = nil
    RapidTransit::Base.actions.actions.should eq []
    RapidTransit::Base.actions.columns.should eq []
  end

  it "defines before and after parse" do
    defined?(RapidTransit::Base.before_parse).should eq "method"
    defined?(RapidTransit::Base.after_parse).should eq "method"
  end

  it "parses the file" do
    pending
  end
end
