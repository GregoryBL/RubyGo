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
            i.group = nil
        }
    end
    
    def add_point (point)
        @points << point
        @liberties.remove(point)
    end
    
    def combine_group (group)
        @liberties.union(group.liberties)
        group.points.each{|i|
            self.add_point(i)
        }
        group.dead
    end
end