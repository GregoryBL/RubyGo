# Ruby Go : Greg Berns-Leone
# RGPoint.rb
#
# Represents a point (location) on the goban.
# 
# Responsible for taking legal user actions from RGBoard and passing that information
# to relevant groups and other points. It also should add and remove stones. RGBoard
# is a collection of RGPoints.

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
        @liberty_of = Set.new #groups
        @group = nil
        @will_kill = Set.new
        @ko_point = false
    end
    
    def init_neighbors
        b_s = @board.size
        @top = location.divmod(b_s)[0] < (b_s - 1) ? @board.get_point(location + b_s) : nil
        @left = location.divmod(b_s)[1] != 0 ? @board.get_point(@location - 1) : nil
        @right = location.divmod(b_s)[1] != (b_s - 1) ? @board.get_point(@location + 1) : nil
        @bottom = location.divmod(b_s)[0] > 0 ? @board.get_point(@location - b_s) : nil
        @neighbors = [@top, @right, @bottom, @left].keep_if {|i| i }
        @open_neighbors = [@top, @right, @bottom, @left].keep_if {|i| i }
    end
    
    def add_stone (color) #not an illegal move and is color's turn
        #place stone
        @color = color 
        
        #kill any group in atari
        @will_kill.each{|i| if i[0] != color then i[1].dead end }
        
        #test
        puts self.to_s + " is a liberty of:"
        @liberty_of.each{|i| puts i}
        
        #find any groups of the same color that are connected.
        connected_groups = Set.new
        @liberty_of.each{|i|
            if i.color == color
                connected_groups.add(i)
                i.remove_liberty(self)
            else
                i.remove_liberty(self)
            end }
            
        #create a new group or tell groups to connect and add self
        if connected_groups.length == 0
            @group = Group.new(self)
            puts "no connected groups"
        elsif connected_groups.size == 1
            @group = connected_groups.to_a[0]
            @group.add_point(self)
            puts "one connected group"
        else
            @group = connected_groups.to_a.inject{|result, n| result.combine_group(n)}
            puts connected_groups.length.to_s + " connected groups"
            #puts @group.to_s
        end
        
        #tell open neighbors they are a liberty of this group
        @open_neighbors.each{|i| i.add_liberty_of(@group)}
        
        #tell neighbors self is no longer an open neighbor
        @neighbors.each{|i| i.remove_open_neighbor(self)}
        
        #tests
        puts "color = " + color.to_s
        puts "location = " + location.to_s
        puts "neighbors = " + neighbors.inject(""){|string, i| string + i.to_s}
        puts "open_neighbors = " + open_neighbors.inject(""){|string, i| string + i.to_s}
        puts "group = " + group.to_s
        puts ""
    end
    
    def remove_stone
        puts "remove_stone_called"
        @neighbors.each{|i| i.open_neighbors.push(self)}
        if color == :black
            @board.white_captures += 1
        else
            @board.black_captures += 1
        end
        @color = nil
        @group = nil
    end
    
    def to_s
        "[" + @location.to_s + " : " + @color.to_s + "]"
    end
    
    protected
    
    def remove_open_neighbor (point)
        @open_neighbors.delete(point)
        if @group 
            @group.remove_liberty(point)
        end
    end
    
    def add_liberty_of (group)
        group.liberties.add(self)
        @liberty_of.add(group)
    end
end