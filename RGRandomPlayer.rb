# Ruby Go : Greg Berns-Leone
# RGRandomPlayer.rb
#
# Plays random points

class RGRandomPlayer
    def initialize(game)
        @game = game
        @random = Random.new
        @size = @game.size
        @color
    end
    
    def change_size(size)
        @size = size
    end
    
    def genmove(color)
        newrand = @random.rand(@size * @size)
        
        if !@game.board.get_point(newrand).color && !@game.board.get_point(newrand).open_neighbors.empty?
            @game.board.play(color, newrand)
            return newrand
        else
            return self.genmove(color)
        end
    end
end