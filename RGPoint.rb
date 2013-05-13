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
    
    attr_reader :location, :color, :neighbors, :open_neighbors, :row, :column
    attr_accessor :will_kill, :ko_point, :group, :filled_neighbors
    attr_accessor :cdr, :cdl, :osd, :osl, :kld, :klu, :kdr, :kdl, :lkld, :lklu, :lkdr, :lkdl
    
    def initialize (location,board)
        @board = board
        @size = @board.size
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
        @cdr = nil
        @cdl = nil
        @osd = nil
        @osl = nil
        @kld = nil
        @klu = nil
        @kdr = nil
        @kdl = nil
        @tsl = nil
        @tsd = nil
        @lkld = nil
        @lklu = nil
        @lkdr = nil
        @lkdl = nil
    end
    
    def init_neighbors
        @top = self.row < @size ? @board.get_point(location + @size) : nil
        @left = self.column != 1 ? @board.get_point(@location - 1) : nil
        @right = self.column != @size ? @board.get_point(@location + 1) : nil
        @bottom = self.row > 1 ? @board.get_point(@location - @size) : nil
        @neighbors = [@top, @right, @bottom, @left].keep_if {|i| i }
        @open_neighbors = [@top, @right, @bottom, @left].keep_if {|i| i }
        self.init_extensions
    end
    
    def init_extensions #set bidirectionally
        n_up = 0
        n_right = true
        if @row <= 1
            @krd = nil
            @lkrd = nil
            n_up = -1
        end
        if @row >= @size
            @cur = nil
            @cul = nil
            @kru = nil
            @lkru = nil
            n_up = 1
        end
        if @row >= (@size - 1)
            @osu = nil
            @kur = nil
            @kul = nil
            n_up = 2
        end
        if @row >= (@size - 2)
            @tsu = nil
            @lkur = nil
            @lkul = nil
            n_up = 3
        end
        
        if @column <= 1
            @kul = nil
            @lkul = nil
            n_right = -1
        end
        if @column >= @size
            @cur = nil
            @kur = nil
            @lkur = nil
            n_right = 1
        end
        if @column >= (@size - 1)
            @osr = nil
            @krd = nil
            @kru = nil
            n_right = 2
        end
        if @column >= (@size - 2)
            @tsr = nil
            @lkru = nil
            @lkrd = nil
            n_right = 3
        end
        
        if n_up > -1
            if n_right < 2
                krd = @board.get_point(@location - @size + 2)
                @krd = krd
                @krd.klu = self
            end
            if n_right < 3
                lkrd = @board.get_point(@location - @size + 3)
            end
        end
        if n_up < 3
            if n_right 
        
    end
    
    def add_stone (color) #not an illegal move and is color's turn
        #place stone
        @color = color 
        
        #kill any group in atari and clear list
        @will_kill.each{|i| if i[0] != color then i[1].dead end }
        @will_kill = Set.new
        
        #find any groups of the same color that are connected.
        @group = Group.new(self, @board)
        @filled_neighbors.each{|i|
            if i.color == color
                @group.combine_group(i.group, self)
            else
                i.group.remove_liberty(self)
            end }
        
        #tell neighbors this location is no longer an open neighbor
        @neighbors.each{|i| 
            i.remove_open_neighbor(self)}
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