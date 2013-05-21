# Ruby Go : Greg Berns-Leone
# RGPlayer.rb
#
# Abstract player class

class RGPlayer
    
    attr_accessor :komi, :size, :board
    
    def initialize(game, size=19)
        @game = game
        @size = size
        @color = nil
        @komi = 0
        @log = File.new("game_log.txt", "w")
        
        set_board
        
    end
    
    def set_board
        @board = Board.new(@size, @log)
    end
    
    def change_size(size)
        @size = size
        set_board
    end
    
    def genmove(color)
        if !@color
            @color = color
        end
        
        move = self.generate_move
        
        @board.play(color, move)
        
        move
    end
end