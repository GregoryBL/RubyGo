#!/usr/bin/env ruby

# Ruby Go : Greg Berns-Leone
# GoMaster.rb
#
# Sets up the game.

require_relative './RGBoard'
require_relative './RGPoint'
require_relative './RGGroup'
require_relative "Gtp.rb"
require_relative "RGgtp.rb"
require_relative "RGRandomPlayer.rb"
require_relative "Player1.rb"

class Go
    
    attr_accessor :gtp, :player
    
    def initialize (player="random")
        #@root = GoRoot.new(size)
        if player == "random"
            @player = RGRandomPlayer.new(self) 
        elsif player == "Player1"
            @player = Player1.new(self)
        else
            raise "Error: not a real player"
        end
        @gtp = RGgtp.new(self, @player)  
    end
    
    def change_size (size)
        @player.change_size(size)
    end
end
    
gtp = Gtp.new(Go.new.gtp, $stdin, $stdout, File.new("log.txt", "w"), true)
gtp.ProcessCommands