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
    
    attr_reader :location, :color, :top, :left, :right, :bottom, :neighbors, :open_neighbors
    attr_accessor :will_kill, :ko_point, :group
    
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
        
        #kill any group in atari and clear list
        @will_kill.each{|i| if i[0] != color then i[1].dead end }
        @will_kill = Set.new
        
        #test
        puts self.to_s + " is a liberty of:"
        @liberty_of.each{|i| puts i}
        
        #find any groups of the same color that are connected.
        @group = Group.new(self)
        @liberty_of.each{|i|
            if i.color == color
                puts "connected " + i.to_s + " to " + @group.to_s
                @group.combine_group(i, self)
                puts @group.to_s
            else
                i.remove_liberty(self)
            end }
        
        #tell open neighbors they are a liberty of this group
        @open_neighbors.each{|i| i.add_liberty_of(@group)}
        
        #tell neighbors this location is no longer an open neighbor
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
    
    def liberty_of
        lib_of = Array.new
        (@neighbors - @open_neighbors).each{|i| lib_of.push(i.group).compact}
        lib_of
    end
    
    protected
    
    def remove_open_neighbor (point)
        @open_neighbors.delete(point)
    end
    
    
end