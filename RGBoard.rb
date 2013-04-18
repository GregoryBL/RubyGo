# Ruby Go : Greg Berns-Leone
# RGBoard.rb
#
# Represents the goban.
# 
# Responsible for initializing the points, validating whether moves are legal,
# and keeping track of turns and captures. Also serves the point for a location.

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

        result_liberties = 0
        point.neighbors.each {|i| if i.color == color
            result_liberties += (i.group.num_liberties - 1)
        end }
        
        nothing_killed = true
        point.will_kill.each {|i| if i[0] != color then nothing_killed = false end }
        old_ko = @ko_point ? self.ko_point.location : nil
        if color != turn
            raise "Not your turn"
        elsif point.color
            raise "Illegal Move: Point occupied"
        elsif point.open_neighbors.empty? && nothing_killed && result_liberties == 0
            raise "Illegal Move: Suicide"
        elsif point.ko_point
            raise "Illegal Move: Ko"
        else
            puts "add_stone called at location: " + location.to_s
            point.add_stone(color)
        end
        puts "ko_point: " + @ko_point.to_s + " old_ko: " + old_ko.to_s
        if (@ko_point && (@ko_point.location == old_ko))
            @ko_point.remove_ko_point
            set_ko(nil)
        end
        puts "ko_point: " + @ko_point.to_s + " old_ko: " + old_ko.to_s
        @turn = ((turn == :black) ? :white : :black)
    end
    
    def set_ko (kopoint)
        @ko_point = kopoint
    end
end