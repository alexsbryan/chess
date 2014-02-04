require_relative 'piece'

class King < SteppingPiece

  def initialize(color, pos, board=nil)
    super(color,pos,board)
    @move_units = [
    [-1, 1],
    [-1, -1],
    [-1, 0],
    [0, 1],
    [0, -1],
    [1, 1],
    [1, 0],
    [1, -1]
  ]
  end

  def possible_moves
    super(@move_units)
  end

end


class Knight < SteppingPiece

  def initialize(color, pos, board=nil)
    super(color,pos,board)
    @move_units = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]
  end

  def possible_moves
    super(@move_units)
  end


end

private

class SteppingPiece < Piece
#Initialize a move possibilities  Kings, Knights

  def possible_moves(move_units)
    valid_moves = []
    x, y = self.position

    move_units.each do |(dx, dy)|
      new_position = [x + dx, y + dy]
      if new_position[0].between?(0,7) && new_position[1].between?(0,7)
        # not valid if new position is already occupied (ask self.board)
        valid_moves << new_position
      end
    end

    valid_moves
  end


end