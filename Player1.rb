# Ruby Go : Greg Berns-Leone
# RGPlayer.rb
#

class Player1 < RGPlayer
    
    def initialize (game, size=19)
        super
        @counter = 0
    end
        
    def generate_move
        point = self.board.get_point(@counter)
        new_counter = point.kur.location
        if !point.color
            @counter = new_counter
            point.location
        else
            @counter = @board.get_point_cr(point.column - 1, point.row + 1).location
            @board.log.write("hit another stone")
            self.generate_move
        end
    end 
    
end
        