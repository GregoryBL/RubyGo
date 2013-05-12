# Ruby Go : Greg Berns-Leone
# RGBoard.rb
#
# Represents the goban.
# 
# Responsible for initializing the points, validating whether moves are legal,
# and keeping track of turns and captures. Also serves the point for a location.

class Board
    
    attr_accessor :size, :ko_point, :turn, :white_captures, :black_captures, :log
    
    def initialize (size=19, log)
        @size = size
        @log = log
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
    
    def set_handicap (handicap)
        max_handicap = 0
        dist_from_wall = 0
        
        if (@size % 2) == 1
            if @size < 6
                max_handicap = 0
            elsif @size < 8
                max_handicap = 4
            else
                max_handicap = 9
            end
        else
            if @size > 7
                max_handicap = 4
            else
                max_handicap = 0
            end
        end
        
        if @size < 14
            dist_from_wall = 3
        else
            dist_from_wall = 4
        end
        
        emp_below = @size * (dist_from_wall - 1)
        num_pos = @size * @size - 1
        half = num_pos / 2
        
        handicap_positions = [
            emp_below + dist_from_wall - 1,
            num_pos - (emp_below + dist_from_wall - 1),
            emp_below + @size - dist_from_wall,
            num_pos - (emp_below + @size - dist_from_wall),
        ]
        if max_handicap > 4
            handicap_positions.push(emp_below + @size.div(2), 
            num_pos - (emp_below + @size.div(2)), 
            half - @size.div(2) + dist_from_wall - 1, 
            half + @size.div(2) - (dist_from_wall - 1))
        end
        
        handicap_positions = handicap_positions.reverse
        
        if handicap > 4 && (handicap % 2) == 1
            self.play(:black, half, true)
            handicap -= 1
        end
        
        handicap.times {|i|
            self.play(:black, handicap_positions.pop, true)
        }
        @turn = :white
    end
    
    def play (color, location, handicap=false)
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
            raise "Illegal Move: Point occupied" + location.to_s
        elsif point.open_neighbors.empty? && nothing_killed && result_liberties == 0
            raise "Illegal Move: Suicide"
        elsif point.ko_point
            raise "Illegal Move: Ko"
        else
            @log.write("add_stone called with color: " + color.to_s + "at location: " + location.to_s + "\n")
            point.add_stone(color)
        end
        @log.write("ko_point: " + @ko_point.to_s + " old_ko: " + old_ko.to_s + "\n")
        if (@ko_point && (@ko_point.location == old_ko))
            @ko_point.remove_ko_point
            set_ko(nil)
        end
        @log.write("ko_point: " + @ko_point.to_s + " old_ko: " + old_ko.to_s + "\n")
        if !handicap
            @turn = ((turn == :black) ? :white : :black)
            @log.write(@turn.to_s + "\n")
        end
    end
    
    def set_ko (kopoint)
        @ko_point = kopoint
    end
end