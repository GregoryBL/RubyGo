# Ruby Go : Greg Berns-Leone
# RGGraphics.rb
#
# Provides a rudementary representation of the game.

require 'tk'

class GoRoot
    def initialize (size)
        @root = TkRoot.new('height' => 50 * (size + 1), 'width' => 50 * (size + 1), 'background' => 'grey') {title 'Go'}
    end
    
    def bind(char, callback)
        @root.bind(char, callback)
    end
    
    attr_reader :root
end

class GoCanvas
    def initialize
        @canvas = TkCanvas.new('background' => 'gold')
    end
    
    def place(height, width, x, y)
        @canvas.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
    end
    
    def unplace
        @canvas.unplace
    end
    
    def delete
        @canvas.delete
    end
    
    attr_reader :canvas
end

def mainLoop
    Tk.mainloop
end

def exitProgram
    Tk.exit
end

