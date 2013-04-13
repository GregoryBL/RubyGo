class Point
    
    attr_reader :location, :color, :top, :left, :right, :bottom, :neighbors, :open_neighbors, :group, :liberty_of
    attr_accessor :will_kill, :ko_point
    
    def initialize (location,board)
        @board = board
        @location = location
        @color = nil # nil, :black, or :white
        @top = location.divmod(@board.size)[0] < @board.size ? @board.get_point(point + @size) : nil
        @left = location.divmod(@board.size)[1] != 1 ? @board.get_point(point - 1) : nil
        @right = location.divmod(@board.size)[1] != @board.size ? @board.get_point(point + 1) : nil
        @bottom = location.divmod(@board.size)[0] > 1 ? @board.get_point(point - @size) : nil
        @neighbors = [@top, @right, @bottom, @neighbors].keep_if {|i| i }
        @open_neighbors = @neighbors
        @liberty_of = Set.new #groups
        @group = nil
        @will_kill = Set.new
        @ko_point = false
    end
            
    def add_stone (color) #not an illegal move and is color's turn
        @color = color
        @will_kill.each{|i| i.dead}
        
        connected_groups = Set.new
        @liberty_of.each{|i| if i.color == color then connected_groups.add(i.group) end}
            
        if !connected_groups
            @group = Group.new(self)
        elsif connected_groups.size = 1
            @group = connected_groups.take(1)
            @group.add_point(self)
        else
            @group = connected_groups.inject(Group.new(self)){|result, n| result.combine_group(n)}
        end
        @neighbors.each{|i| i.filled_neighbor(self)}
        @open_neighbors.each{|i| i.add_liberty_of(group)}
        
    end
    
    def remove_stone
        @neighbors.each{|i| i.open_neighbors.push(self)}
        if color == :black
            @board.white_captured
        else
            @board.black_captured
        end
    end
    
    protected
    
    def remove_open_neighbor (point)
        @open_neighbors.remove(point)
    end
    
    def add_liberty_of (group)
        group.liberties.add(self)
    end
end