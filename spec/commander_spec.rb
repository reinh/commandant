require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Commander do
  before  { Commander.clear! }

  describe ".command" do
    subject { Commander.command(:test) { "this is a test" } }
    it "creates a new Command with the given name and command block" do
      should be_a_kind_of(Commander::Command)
    end
  end

  describe ".call" do
    it "calls the given command" do
      Commander.command(:test) { "test" }
      Commander.call(:test).should == "test"
    end

    it "passes args if given" do
      Commander.command(:test) {|args| args }

      Commander.call(:test, "args").should == "args"
    end

    describe "when the command is unavailable" do
      subject { lambda{Commander.call(:missing)} }
      it { should raise_error(Commander::UnknownCommand) }
    end
  end

  describe ".clear!" do
    before { Commander.command(:main){"main"} }

    it "should empty the command list" do
      lambda {
        Commander.clear!
      }.should change{Commander::COMMANDS.empty?}.from(false).to(true)
    end
  end

  describe ".run" do
    before { Commander.command(:main) { } }

    it "runs the command specified" do
      Commander::COMMANDS[:main].should_receive(:call)

      Commander.run("main")
    end

    it "runs the command with arguments" do
      Commander::COMMANDS[:main].should_receive(:call).with(["args"])

      Commander.run(%w{main args})
    end
  end

end
