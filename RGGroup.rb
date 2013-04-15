# Ruby Go : Greg Berns-Leone
# RGGroup.rb
#
# Represents a solidly connected group of stones.
# 
# Responsible for keeping track of liberties, adding points, combining with other
# groups, and deleting itself if captured.

class Group
    
    attr_accessor :points, :liberties, :color
    
    def initialize (point)
        @color = point.color
        @points = Set.new << point
        @liberties = Set.new
        init_liberties(point)
    end
    
    def init_liberties (point)
        if point.top && !point.top.color
            @liberties.add(point.top)
        end
        if point.left && !point.left.color
            @liberties.add(point.left)
        end
        if point.right && !point.right.color
            @liberties.add(point.right)
        end
        if point.bottom && !point.bottom.color
            @liberties.add(point.bottom)
        end
    end
    
    def num_liberties
        liberties.size
    end
    
    def dead
        @points.each{|i|
            i.remove_stone
        }
    end
    
    def add_point (point)
        @points << point
        @liberties.delete(point)
    end
    
    def combine_group (group)
        @liberties.union(group.liberties)
            
        group.points.each{|i|
            self.add_point(i)
        }
        if num_liberties == 1
            @liberties.each #NEEDS HELP
        end
        #group.dead
    end
    
    def remove_liberty (point)
        @liberties.delete(point)
        if num_liberties == 1
            @liberties.each{|i| i.will_kill.add([color, self])}
        end
    end
    
    def to_s
        "Color: " + @color.to_s + ", Points: " + @points.inject(""){|string, i| string + i.to_s} + ", Liberties: " + @liberties.inject(""){|string, i| string + i.to_s}
    end
end