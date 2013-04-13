require 'Set'

class Point
    
    attr_reader :location, :color, :top, :left, :right, :bottom, :neighbors, :open_neighbors, :group, :liberty_of
    attr_accessor :will_kill, :ko_point
    
    def initialize (location,board)
        @board = board
        @location = location
        @color = nil # nil, :black, or :white
        @top = nil
        @left = nil
        @right = nil
        @bottom = nil
        @neighbors = nil
        @open_neighbors = nil
        @liberty_of = Object::Set.new #groups
        @group = nil
        @will_kill = Set.new
        @ko_point = false
    end
    
    def init_neighbors
        b_s = @board.size
        @top = location.divmod(b_s)[0] < b_s ? @board.get_point(location + b_s) : nil
        @left = location.divmod(b_s)[1] != 1 ? @board.get_point(@location - 1) : nil
        @right = location.divmod(b_s)[1] != b_s ? @board.get_point(@location + 1) : nil
        @bottom = location.divmod(b_s)[0] > 1 ? @board.get_point(@location - b_s) : nil
        @neighbors = [@top, @right, @bottom, @left].keep_if {|i| i }
        @open_neighbors = @neighbors
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