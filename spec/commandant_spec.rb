require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Commandant do
  before  { Commandant.clear! }

  describe ".call" do
    it "calls the given command" do
      Commandant.command(:test) { "test" }
      Commandant.call(:test).should == "test"
    end

    it "passes args if given" do
      Commandant.command(:test) {|args| args }

      Commandant.call(:test, "args").should == "args"
    end

    describe "when the command is unavailable" do
      subject { lambda{Commandant.call(:missing)} }
      it { should raise_error(Commandant::UnknownCommand) }
    end
  end

  describe ".clear!" do
    before { Commandant.command(:main){"main"} }

    it "should empty the command list" do
      lambda {
        Commandant.clear!
      }.should change{Commandant::COMMANDS.empty?}.from(false).to(true)
    end
  end

  describe ".add_alias" do
    it "creates an alias for a given command" do
      Commandant.command(:hello) { "hello" }
      Commandant.add_alias :hi => :hello

      Commandant.run(:hi).should == "hello"
    end
  end

  describe ".command" do
    subject { Commandant.command(:test) { "this is a test" } }
    it "creates a new Command with the given name and command block" do
      should be_a_kind_of(Commandant::Command)
    end
  end

  describe ".run" do
    before { Commandant.command(:main) {|args| "main called with #{args.inspect}" } }

    it "runs the command specified" do
      Commandant::COMMANDS[:main].should_receive(:call)

      Commandant.run("main")
    end

    it "runs the command with arguments" do
      Commandant::COMMANDS[:main].should_receive(:call).with(["args"])

      Commandant.run(%w{main args})
    end

    it "defaults to the :main command, if available" do
      Commandant.run(%w{ some args }).should == 'main called with ["some", "args"]'
    end

    it "runs the main command if no arguments are passed" do
      Commandant.run(nil).should == "main called with []"
    end

    it "raises an errur of no main command is available" do
      Commandant.clear!

      lambda {
        Commandant.run(%w{ some args })
      }.should raise_error(Commandant::UnknownCommand)
    end

  end

end
