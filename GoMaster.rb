# Ruby Go : Greg Berns-Leone
# GoMaster.rb
#
# Sets up the game and the graphics.

#require_relative './RGGraphics'
require_relative './RGBoard'
require_relative './RGPoint'
require_relative './RGGroup'
require_relative "Gtp.rb"
require_relative "RGgtp.rb"

class Go
    
    attr_accessor :board, :gtp, :komi
    
    def initialize (size=9)
        #@root = GoRoot.new(size)
        @size = size
        @komi = 0
        set_board
        @gtp = RGgtp.new(self)
    end
    
    def set_board
        #@canvas = GoCanvas.new
        @board = Board.new(@size)
        #@canvas.place((@size+1)*50, (@size+1)*50, 0, 0)
        #(1..@size).each {|i| 
        #    j = i * 50
        #    TkcLine.new(@canvas.canvas, j, 50, j, @size*50)
        #    TkcLine.new(@canvas.canvas, 50, j, @size*50, j)
        #}
    end
    
    def change_size (size)
        @size = size
        set_board
    end
end
    
gtp = Gtp.new(Go.new.gtp, $stdin, $stdout, File.new("log.txt", "w"), true)
gtp.ProcessCommands