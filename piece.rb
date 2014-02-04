require_relative 'chess'

class Piece
  ##Process a move from game, return errors if move not possible, otherwise moves to positions(or some other class does moving, it just confirms validity and changes it's current position)

  attr_accessor :position

  def initialize color, position, board = nil
    @color = color
    @position = position
    @board = board
  end

  def move

  end

  def possible_moves
    # return an array of positions to move to
  end


end


class Pawn < Piece

  #TODO: depending on game state and whether it's claiming a piece it's moves are different
  def initialize(color, pos, board=nil)
    super(color,pos,board)
    @move_units = [
      [1,1],
      [-1,1],
      [0,1]
    ]

  end

  def possible_moves
    valid_moves = []
    direction = self.direction
    x, y = self.position

    @move_units.each do |(dx, dy)|
      new_position = [x + (direction * dx), y + (direction * dy)]
      if new_position[0].between?(0,7) && new_position[1].between?(0,7)
        # not valid if new position is already occupied (ask self.board)
        valid_moves << new_position
      end
    end

    valid_moves
  end

  def direction
    direction = 0
    if @color == :b
      direction = -1
    else
      direction = 1
    end
  end
end

