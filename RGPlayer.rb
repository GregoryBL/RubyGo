# Ruby Go : Greg Berns-Leone
# RGPlayer.rb
#
# Abstract player class

class RGPlayer
    def initialize(game)
        @game = game
        @board = @game.board
        @size = @game.size
        @color = nil
    end
    
    def change_size(size)
        @size = size
    end
    
    def genmove(color)
        if !@color
            @color = color
        end
        # Fill with move generation
        
        move = nil
        
        @board.play(color, move) 
    end
end