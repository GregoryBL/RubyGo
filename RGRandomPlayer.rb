# Ruby Go : Greg Berns-Leone
# RGRandomPlayer.rb
#
# Plays random points
require_relative "RGPlayer.rb"

class RGRandomPlayer < RGPlayer
    def initialize(game)
        super
        @random = Random.new
    end
    
    def genmove(color)
        newrand = @random.rand(@size * @size)
        
        if !@board.get_point(newrand).color && !@board.get_point(newrand).open_neighbors.empty?
            @board.play(color, newrand)
            return newrand
        else
            return self.genmove(color)
        end
    end
end