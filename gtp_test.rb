#!/usr/bin/env ruby

require_relative "Gtp.rb"

class CommandLineEngine
    def init
        @size = nil
        @board = Array.new(size ** 2)
    end
    
    def gtp_name
        "Command Line Engine"
    end
    
    def gtp_version
        "0.0.1"
    end
    
    def gtp_boardsize (size)
        if size.to_i >= 25
            raise "unacceptable size"
        else
            @size = size.to_i
        end
    end
    
    def gtp_clear_board
        @board = Array.new(@size * @size)
    end
    
    def gtp_komi (new_komi)
        @komi = new_komi
    end
    
    def gtp_play (*move)
    end
    
    def gtp_genmove (color)
        gets.chomp
    end
end

gtp = Gtp.new(CommandLineEngine.new, $stdin, $stdout, File.new("log.txt", "w"), true)
gtp.ProcessCommands