require 'spec_helper'

require 'spec_helper'

describe RapidTransit::ActionList do
  let(:action_list){ RapidTransit::ActionList.new }
  it "has attr_accessors for columns and actions" do
    action_list.should respond_to(:columns)
    action_list.should respond_to(:actions)
  end

  it "adds an action to the list" do
    action = mock(RapidTransit::Action)
    action.stub!(:valid? => true)
    action_list.add(action)
    action_list.actions.size.should eq 1
    action_list.actions[0].class.should eq RSpec::Mocks::Mock
  end

  it "should iterate over actions" do
    action = mock(RapidTransit::Action)
    action.stub!(:valid? => true)
    action_list.add(action)
    action_list.each do |action|
      action.class.should eq RSpec::Mocks::Mock
    end
  end

  it "should return empty array if no keys are present" do
    action_list.keys.should eq []
  end

  it "should return keys if keys have been set" do
    action = mock(RapidTransit::Action)
    action.stub!(:valid? => true)
    action.stub!(:key => "key_name")
    action_list.add(action)
    action_list.keys.should eq ["key_name"]
    action_list.add(action)
    action_list.keys.should eq ["key_name","key_name"]
  end
end
