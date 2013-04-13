class Board
    
    attr_accessor :size, :ko_point :turn
    
    def initialize (size=19)
        @size = size
        @board = Array.new(@size * @size) {|i| Point.new(i, self)}
        @turn = :black
        @groups = Array.new
    end
    
    def get_point (location)
        @board[location]
    end
    
    def play (color, location)
        point = get_point(location)
        
        if color != turn
            raise "Not your turn"
        elsif !point.color
            raise "Illegal Move: Point occupied"
        elsif point.open_neighbors.empty? && point.will_kill.empty?
            raise "Illegal Move: Suicide"
        elsif point.ko_point?
            raise "Illegal Move: Ko"
        else
             point.add_stone(color)
        end
        
        turn = turn == :black ? :white : :black
    end     
end