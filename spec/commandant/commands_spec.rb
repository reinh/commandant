require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Commandant::Command do
  before  { Commandant.clear! }
  subject { Commandant::Command }

  describe ".new" do
    it "requres a name" do
      lambda { subject.new(){ "this is the command" }
      }.should raise_error(ArgumentError)
    end

    it "requires a block" do
      lambda { subject.new(:name)
      }.should raise_error(ArgumentError)
    end

    it "accepts a description" do
      subject.new(:name, "description"){}.description.should == "description"
    end

    it "adds the command to the list of commands by name" do
      command = subject.new(:name){ "block" }
      Commandant::COMMANDS[:name].should == command
    end

    describe "when the command already exists" do
      before { Commandant::Command.new(:dup) { "I am a duplicate" } }

      it do
        lambda {
          Commandant.command(:dup) { "I am a duplicate" }
        }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#call" do
    subject { Commandant::Command.new(:name){ "called" } }

    it "calls the given command" do
      subject.call.should == "called"
    end
  end
end
