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
    
    attr_reader :location, :color, :neighbors, :open_neighbors, :row, :column, :top, :bottom, :left, :right
    attr_accessor :will_kill, :ko_point, :group, :filled_neighbors, :will_connect, :will_disconnect
    attr_accessor :cdr, :cdl, :osd, :osl, :kld, :klu, :kdr, :kdl, :lkld, :lklu, :lkdr, :lkdl, :tsd, :tsl
    attr_reader :cul, :kul, :lkul, :tsu, :osu, :cur, :kur, :lkur, :krd, :osr, :kru, :lkrd, :tsr, :lkru
    
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
        @will_connect = Array.new
        @will_disconnect = Array.new
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
        @cul = @board.get_point_cr(self.column - 1, self.row + 1)
        if @cul
            @cul.cdr = self 
        end
        @kul = @board.get_point_cr(self.column - 1, self.row + 2)
        if @kul
            @kul.kdr = self 
        end
        @lkul = @board.get_point_cr(self.column - 1, self.row + 3)
        if @lkul
            @lkul.lkdr = self 
        end
        @osu = @board.get_point_cr(self.column, self.row + 2)
        if @osu
            @osu.osd = self 
        end
        @tsu = @board.get_point_cr(self.column, self.row + 3)
        if @tsu
            @tsu.tsd = self 
        end
        @cur = @board.get_point_cr(self.column + 1, self.row + 1)
        if @cur
            @cur.cdl = self 
        end
        @kur = @board.get_point_cr(self.column + 1, self.row + 2)
        if @kur
            @kur.kdl = self 
        end
        @lkur = @board.get_point_cr(self.column + 1, self.row + 3)
        if @lkur
            @lkur.lkdl = self 
        end
        @krd = @board.get_point_cr(self.column + 2, self.row - 1)
        if @krd
            @krd.klu = self 
        end
        @osr = @board.get_point_cr(self.column + 2, self.row)
        if @osr
            @osr.osl = self 
        end
        @kru = @board.get_point_cr(self.column + 2, self.row + 1)
        if @kru
            @kru.kld = self 
        end
        @lkrd = @board.get_point_cr(self.column + 3, self.row - 1)
        if @lkrd
            @lkrd.lklu = self 
        end
        @tsr = @board.get_point_cr(self.column + 3, self.row)
        if @tsr
            @tsr.tsl = self 
        end
        @lkru = @board.get_point_cr(self.column + 3, self.row + 1)
        if @lkru
            @lkru.lkld = self 
        end
        
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