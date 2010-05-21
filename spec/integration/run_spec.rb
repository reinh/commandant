require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Integration:", "Running a command" do
  def running(args, &block)
    IO.popen "ruby spec/fixtures/basic_runner.rb #{args}", &block
  end
  private :running

  describe "that prints \"main\" to STDOUT" do
    it "should output \"main\" to STDOUT" do
      running :main do |io|
        io.read.should == "main"
      end
    end
  end

  describe "that prints its arguments to STDOUT" do
    it "should output its arguments to STDOUT" do
      running "argprinter foo biz bazz" do |io|
        io.read.should == %w{foo biz bazz}.inspect
      end
    end
  end
end
