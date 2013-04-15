# Ruby Go : Greg Berns-Leone
# GoMaster.rb
#
# Sets up the game and the graphics.

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

game = Go.new(9)
game.board.play(:black, 0)
game.board.play(:white, 1)
game.board.play(:black, 9)
game.board.play(:white, 19)
game.board.play(:black, 18)
game.board.play(:white, 10)

puts game.board.get_point(0).to_s
puts game.board.get_point(0).group.to_s