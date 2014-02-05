# encoding: utf-8
# private ??? protected
class SteppingPiece < Piece
#Initialize a move possibilities  Kings, Knights
  def possible_moves(move_units)
    valid_moves = []
    x, y = self.position

    move_units.each do |(dx, dy)|
      new_position = [x + dx, y + dy]
      if new_position[0].between?(0,7) && new_position[1].between?(0,7)
        unless piece_in_way?(self.position, new_position)
          valid_moves << new_position
        end
      end
    end

    valid_moves
  end
end


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

  def render
    if @color == :w
      "\u2654"
    else
      "\u265a"
    end
  end

end


class Knight < SteppingPiece
  #only Knight doesn't care what is in its way
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
    valid_moves = []
    x, y = self.position

    @move_units.each do |(dx, dy)|
      new_position = [x + dx, y + dy]
      if new_position[0].between?(0,7) && new_position[1].between?(0,7)
        unless piece_in_way?(self.position, new_position)
          valid_moves << new_position
        end
      end
    end

    valid_moves
  end

  def piece_in_way?(start_position, end_position)
    piece = @board.board[end_position[0]][end_position[1]]
    return false if piece.nil?
    unless piece.color == @color
      return false
    end
    true
  end

  def render
    if @color == :w
      "\u2658"
    else
      "\u265e"
    end
  end

end