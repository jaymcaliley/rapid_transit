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

  it "raises argerror on_error without block" do
    expect { RapidTransit::Base.on_error }.should raise_error
  end

  it "raises argerror on_error if block arity is not 2" do
    expect { RapidTransit::Base.on_error {|test| puts "test" }}.should raise_error
  end

  it "does not raise error on_error if block arity is 2" do
    expect { RapidTransit::Base.on_error {|test, test2| puts "test" }}.should_not raise_error
  end
end
