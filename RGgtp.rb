class RGgtp

    def initialize(game, player)
        @game = game
        @full_cols = ["a", "b", "c", "d", "e", "f", "g", "h", "j", 
            "k", "l", "m", "n", 
            "o", "p", "q", "r", "s", "t", 
            "u", "v", "w", "x", "y", "z"
        ]
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
            @cols = @full_cols.first(size.to_i)
            @game.change_size(size.to_i)
        end
    end
    
    def gtp_clear_board
        @game.set_board
    end
    
    def gtp_komi (new_komi)
        @game.komi = new_komi
    end
    
    def gtp_play (*move)
        color = self.color_p_for_gtp(move[0])
        @game.board.play(color, self.computer_for_human(move[1]))
    end
    
    def gtp_genmove (color)
        p_color = self.color_p_for_gtp(color)
        move = @game.player.genmove(p_color)
        human = human_for_computer(move)
        return human
    end
    
    def color_p_for_gtp (gtp_color)
        if gtp_color == "b" || gtp_color == "black"
            return :black
        else
            return :white
        end
    end
    
    def color_gtp_for_p (p_color)
        if gtp_color == :black
            return "b"
        else
            return "w"
        end
    end
    
    def computer_for_human (human)
        column = 0
        @cols.each{|i| 
            if i == human[0]
                column = @cols.index(i)
            end 
        }
        row = (human[1].to_i - 1)
        computer = ((row * @game.size) + column)
        return computer
    end
    
    def human_for_computer (computer)
        row = computer.divmod(@game.size)[0] + 1
        column = computer.divmod(@game.size)[1]
        human = @cols[column] + row.to_s
        return human
    end
    
end