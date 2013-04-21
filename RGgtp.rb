class RGgtp

    def initialize(game, player)
        @game = game
        @full_cols = ["a", "b", "c", "d", "e", "f", "g", "h", "j", 
            "k", "l", "m", "n", 
            "o", "p", "q", "r", "s", "t", 
            "u", "v", "w", "x", "y", "z"]
    end
    
    def gtp_name
        "RubyGo"
    end
    
    def gtp_version
        "0.0.1"
    end
    
    def gtp_boardsize (size)
        if size.to_i > 25
            raise "unacceptable size"
        else
            @game.change_size(size.to_i)
            @cols = @full_cols.first(size.to_i)
        end
    end
    
    def gtp_clear_board
        set_board
    end
    
    def gtp_komi (new_komi)
        game.komi = new_komi
    end
    
    def gtp_play (*move)
        if move[0] == "b" || move[0] == "black"
            color = :black
        else
            color = :white
        end
        @game.play(color, self.computer_for_human(move[1]))
    end
    
    def gtp_genmove (color)
        
    end
    
    def computer_for_human (human)
        @cols.each{|i| 
            if i == human[1][0]
                column = cols.index(i)
            end 
        }
        row = (human[1][1] - 1)
        computer = ((row * @size) + column)
        return computer
    end
end
    
end