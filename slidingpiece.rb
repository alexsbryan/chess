require_relative 'piece'

class SlidingPiece < Piece
  #Initialize a move vector Constant, for [Rooks, Queens, Bishops]

  def move
    #slides to edges and only in certain directions

  end
end

class Rook < SlidingPiece

end

class Queen < SlidingPiece

end

class Bishop < SlidingPiece

end