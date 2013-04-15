# Ruby Go : Greg Berns-Leone
# RGBoard.rb
#
# Represents the goban.
# 
# Responsible for initializing the points, validating whether moves are legal, and
# keeping track of turns and captures. Also serves the point for a location.

class Board
    
    attr_accessor :size, :ko_point, :turn, :white_captures, :black_captures
    
    def initialize (size=19)
        @size = size
        @board = Array.new(@size * @size) {|i| Point.new(i, self)}
        @turn = :black
        @groups = Array.new
        @white_captures = 0
        @black_captures = 0
        @board.each{|i| i.init_neighbors }
    end
    
    def get_point (location)
        @board[location]
    end
    
    def play (color, location)
        point = get_point(location)
        
        if color != turn
            raise "Not your turn"
        elsif point.color
            raise "Illegal Move: Point occupied"
        elsif point.open_neighbors.empty? && point.will_kill.empty?
            raise "Illegal Move: Suicide"
        elsif point.ko_point
            raise "Illegal Move: Ko"
        else
             point.add_stone(color)
        end
        
        @turn = ((turn == :black) ? :white : :black)
    end     
end