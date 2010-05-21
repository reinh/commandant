$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'commander/command'

module Commander
  COMMANDS = {}

  class UnknownCommand < NameError
    def initialize(name); super "Unknown command `#{name}`" end
  end

  # Call a given command by name
  #
  # @param [Symbol] name the name of the command to be called
  # @param [Array] args the command's arguments
  # @raise [UnknownCommand] attempt to call a command that does not exist
  def self.call(name, args=nil)
    raise UnknownCommand.new(name) unless COMMANDS[name]
    COMMANDS[name].call(args)
  end

  # Clears out all defined commands.  Primarily useful for testing
  def self.clear!
    COMMANDS.clear
  end

  # Create a new command
  #
  # @param [Symbol] name the name of the command that is created
  # @param [String, nil] description the command's description
  # @yield The command that will be run
  # @yieldparam [Array] args optional: arguments to the command (typically from ARGV)
  #
  # @example A Hello World! command
  #   Commander.command :hello do
  #     puts "Hello World!"
  #   end
  #
  #   Commander.run "hello"
  # 
  # @example A command with arguments
  #   Commander.command :argprint do |args|
  #     puts args
  #   end
  #
  #   Commander.run "argprint foo bizz bazz"
  def command(name, description="", &command)
    Command.new(name, description, &command)
  end
  module_function :command

  # Runs a given commandline by parsing the command name and arguments
  #
  # @param [Array] cmdline the command line args to be run
  def run(cmdline=ARGV)
    name, *args = cmdline
    Commander.call name.to_sym, args
  end
  module_function :run

end