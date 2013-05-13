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
    
    attr_reader :location, :color, :top, :left, :right, :bottom, :neighbors, :open_neighbors, :row, :column
    attr_accessor :will_kill, :ko_point, :group, :filled_neighbors
    
    def initialize (location,board)
        @board = board
        @log = @board.log
        @location = location
        @color = nil # nil, :black, or :white
        @top = nil
        @left = nil
        @right = nil
        @bottom = nil
        @neighbors = nil
        @open_neighbors = nil
        @filled_neighbors = Set.new
        @group = nil
        @will_kill = Set.new
        @ko_point = false
        @row = location.divmod(@board.size)[0] + 1 # 1 to @size
        @column = location.divmod(@board.size)[1] + 1 # 1 to @size
    end
    
    def init_neighbors
        b_s = @board.size
        @top = self.row < b_s ? @board.get_point(location + b_s) : nil
        @left = self.column != 1 ? @board.get_point(@location - 1) : nil
        @right = self.column != b_s ? @board.get_point(@location + 1) : nil
        @bottom = self.row > 1 ? @board.get_point(@location - b_s) : nil
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
        #puts self.to_s + " is a liberty of:"
        #@filled_neighbors.each{|i| puts i.group.to_s}
        
        #find any groups of the same color that are connected.
        @group = Group.new(self, @board)
        @filled_neighbors.each{|i|
            if i.color == color
                #puts "connected " + i.group.to_s + " to " + @group.to_s
                @group.combine_group(i.group, self)
                #puts @group.to_s
            else
                i.group.remove_liberty(self)
            end }
        
        #tell neighbors this location is no longer an open neighbor
        @neighbors.each{|i| 
            i.remove_open_neighbor(self)}
        
        #tests
        #puts "color = " + color.to_s
        #puts "location = " + location.to_s
        #puts "neighbors = " + neighbors.inject(""){|string, i| string + i.to_s}
        #puts "open_neighbors = " + open_neighbors.inject(""){|string, i| string + i.to_s}
        #puts "group = " + group.to_s
        #puts ""
    end
    
    def remove_stone
        @log.write("remove_stone_called" + self.to_s + "\n")
        @neighbors.each{|i| 
            i.open_neighbors.push(self)
            i.filled_neighbors.delete(self) 
        }
        @filled_neighbors.each{|i|
            i.group.add_liberty(self)
        }
        if color == :black
            @board.white_captures += 1
        else
            @board.black_captures += 1
        end
        @color = nil
        @group = nil
    end
    
    def set_ko_point
        @ko_point = true
        @board.set_ko(self)
    end
    
    def remove_ko_point
        @ko_point = false
    end
    
    def to_s
        "[" + @location.to_s + " : " + @color.to_s + "]"
    end
    
    protected
    
    def remove_open_neighbor (point)
        @open_neighbors.delete(point)
        @filled_neighbors.add(point)
    end
    
    
end