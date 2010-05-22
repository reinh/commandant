$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'commandant/command'

module Commandant
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

  # Creates an alias for each given command.
  #
  # @param [Hash<Symbol => Symbol>] commands the aliases to create ( new name => old name )
  # @example
  #   alias :br => :branch, :co => :checkout
  def add_alias(commands)
    commands.each do |new, old|
      Commandant::COMMANDS[new] = Commandant::COMMANDS[old]
    end
  end
  module_function :add_alias

  # Create a new command
  #
  # @param [Symbol] name the name of the command that is created
  # @param [String, nil] description the command's description
  # @yield The command that will be run
  # @yieldparam [Array] args optional: arguments to the command (typically from ARGV)
  #
  # @example A Hello World! command
  #   Commandant.command :hello do
  #     puts "Hello World!"
  #   end
  #
  #   Commandant.run "hello"
  # 
  # @example A command with arguments
  #   Commandant.command :argprint do |args|
  #     puts args
  #   end
  #
  #   Commandant.run "argprint foo bizz bazz"
  def command(name, description=nil, &command)
    Command.new(name, description, &command)
  end
  module_function :command

  # Runs a given commandline by parsing the command name and arguments. If no
  # command is given, defaults to a command called :main. If that is not
  # present, an UnknownCommand error will be raised.
  #
  # @param [Array] cmdline the command line args to be run
  # @raise [UnknownCommand] command is unknown and no :main command is available
  def run(cmdline=ARGV)
    name, *args = cmdline
    name = name.to_sym if name

    name, *args = :main, name, *args unless COMMANDS[name]

    Commandant.call name, args.compact
  end
  module_function :run

end
