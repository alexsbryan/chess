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
  #You're crazy, figure out later

end

