# require_relative 'piece'


# private ???

class SlidingPiece < Piece
  #Initialize a move possibilities Queens, Bishops, Rooks

  def possible_moves(move_units)
    valid_moves = []
    x, y = self.position

    move_units.each do |(dx, dy)|
      (1..7).each do |multiplier|
        new_position = [x + (multiplier * dx), y + (multiplier * dy)]
        if new_position[0].between?(0,7) && new_position[1].between?(0,7)
          valid_moves << new_position unless piece_in_way?(self.position, new_position) # ???
        end
      end
    end

    valid_moves
  end
end


class Rook < SlidingPiece

  def initialize(color, pos, board=nil)
    super(color,pos,board)
    @move_units = [
      [-1, 0],
      [0, 1],
      [0, -1],
      [1, 0]
    ]
  end

  def possible_moves
    super(@move_units)
  end
end

class Queen < SlidingPiece

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

class Bishop < SlidingPiece

  def initialize(color, pos, board=nil)
    super(color,pos,board)
    @move_units = [
      [-1, 1],
      [-1, -1],
      [1, 1],
      [1, -1]
    ]
  end

  def possible_moves
    super(@move_units)
  end

end