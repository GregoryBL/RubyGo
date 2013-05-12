# Public domain code
# Written by Chris Fant (chrisfant@@gmail..com)
# Latest version at http://fantius.com/Gtp.html

class Gtp
  
  def initialize (engine, input, output, log, debugMode)
    @engine = engine
    @input = input
    @output = output
    @debugMode = debugMode
    @output.sync = true
    @commands = {}
    @log = log
    @log.sync = true
    
    AutoRegister(self)
    AutoRegister(@engine)
    
    #Register any commands/functions that could not be auto-registered
    #Reregister any commands/functions that were improperly auto-registered
    if engine.methods.index("gtp_kgs_genmove_cleanup")
      RegisterCommand("kgs-genmove_cleanup", @engine.method(:gtp_kgs_genmove_cleanup))
    end
  end
  
  def AutoRegister(provider)
    #Assumes methods that start with "gtp_" are implemented gtp commands
    for functionName in provider.methods
      if functionName.slice(0,4) == "gtp_"
        RegisterCommand(functionName.slice(4, functionName.length - 1), provider.method(functionName))
      end
    end
  end
  
  def RegisterCommand(name, function)
    #Overrides any previous registration for name or function
    @commands.delete_if {| key, value | value == function }
    @commands[name] = function
  end
  
  def Output(response)
    @log.puts response
    @log.puts
    @output.puts response
    @output.puts
  end
  
  def ProcessCommands()
    #Main GTP command processing loop
    continue = true
    while continue
      continue = ProcessCommand(@input.gets)
    end
  end
  
  def ProcessCommand(commandLine)
    if @debugMode
      ReallyProcessCommand(commandLine)
    else
      begin
        ReallyProcessCommand(commandLine)
      rescue Exception
        Output("? " << $!)
        true
      end
    end
  end
  
  def ReallyProcessCommand(commandLine)
    @log.puts "GTP_INPUT>" << commandLine
    commandParts = commandLine.strip.split(" ")
    command = commandParts[0]
    args = commandParts.slice(1, commandLine.length - 1)
    if command
      if @commands[command]
        Output("= " << @commands[command].call(*args).to_s)
      else
        Output("? Command not implemented: " << command)
      end
    end
    command != "quit"
  end
  
  def TestCommand(commandLine)
    @output.puts "TEST_GTP_INPUT>" << commandLine
    ProcessCommand(commandLine)
  end
  
  def gtp_list_commands(*optionals)
    list = ""
    @commands.keys.sort.each {| commandName | list << commandName << "\n"}
    list
  end
  
  def gtp_protocol_version(*optionals)
    2
  end
  
  def gtp_known_command(command, *optionals)
    @commands.has_key?(command)
  end

  def gtp_quit(*optionals)
    ""
  end

end
