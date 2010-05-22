module Commandant
  class Command
    attr_reader :description

    # Create a new command by name and add it to the commands list.
    #
    # @param [Symbol] name the name of the command
    # @param [String, nil] description the command's description
    # @raise [ArgumentError] if a command block is not provided
    # @raise [ArgumentError] if a command already exists by that name
    def initialize(name, description=nil, &command)
      raise ArgumentError, "Must provide a command block" unless command
      raise ArgumentError, "Command already exists: #{name}" if COMMANDS[name]

      @name        = name
      @description = description
      @command     = command

      COMMANDS[@name] = self
    end

    # Execute the command
    #
    # @param [Array] args the command's arguments
    def call(args=nil)
      @command.call(args)
    end
  end

end
