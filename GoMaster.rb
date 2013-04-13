require_relative './RGGraphics'
require_relative './RGBoard'
require_relative './RGPoint'
require_relative './RGGroup'

class Go
    
    attr_accessor :board
    
    def initialize (size=9)
        @root = GoRoot.new(size)
        @size = size
        set_board
    end
    
    def set_board
        @canvas = GoCanvas.new
        @board = Board.new(@size)
        @canvas.place((@size+1)*50, (@size+1)*50, 0, 0)
        (1..@size).each {|i| 
            j = i * 50
            TkcLine.new(@canvas.canvas, j, 50, j, @size*50)
            TkcLine.new(@canvas.canvas, 50, j, @size*50, j)
        }
    end
end

Go.new(9)