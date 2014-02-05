# encoding: utf-8
require_relative 'piece'
require_relative 'slidingpiece'
require_relative 'steppingpiece'
require 'colorize'

class Board
  attr_accessor :board

  def initialize(testing = false)
    @board = create_empty_board
    unless testing
      populate_board
    end
  end

  def create_empty_board
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    (0..7).each do |x|
      @board[x][1] = Pawn.new(:w, [x, 1], self)
      @board[x][6] = Pawn.new(:b, [x, 6], self)
    end

    (0..7).each do |x|
      if x == 0 || x == 7
        @board[x][0] = Rook.new(:w, [x, 0], self)
        @board[x][7] = Rook.new(:b, [x, 7], self)
      elsif x == 1 || x ==6
        @board[x][0] = Knight.new(:w, [x, 0], self)
        @board[x][7] = Knight.new(:b, [x, 7], self)
      elsif x == 2 || x == 5
        @board[x][0] = Bishop.new(:w, [x, 0], self)
        @board[x][7] = Bishop.new(:b, [x, 7], self)
      elsif x == 3
        @board[x][0] = King.new(:w, [x, 0], self)
        @board[x][7] = King.new(:b, [x, 7], self)
      elsif x == 4
        @board[x][0] = Queen.new(:w, [x, 0], self)
        @board[x][7] = Queen.new(:b, [x, 7], self)
      end
    end
  end

  def print_board
    # simple (only stinks a little!)
    color = :cyan
    piece_color_map = {:b => :black, :w => :magenta}

    @board.each do |row|
      row.each do |piece|
        if piece.nil?
          print "| _ ".colorize(:background => color) # "\u2581"
        else
          print "| #{(piece.render + " ").colorize(:color => piece_color_map[piece.color], :background => color)}".colorize(:background => color)
        end
        color = color == :cyan ? :white : :cyan
      end
      puts
      color = color == :cyan ? :white : :cyan
    end
  end

  def in_check? color
    king_loc = find_king(color)
    opponent = color == :b ? :w : :b

    @board.each do |row|
      row.each do |piece|
        next if piece.nil?
        if piece.color == opponent
          next if piece.possible_moves.nil?
          return true if piece.possible_moves.include?(king_loc)
        end
      end
    end

    false
  end

  def find_king color
    @board.each do |row|
      row.each do |piece|
        if piece.is_a?(King) && piece.color == color
          return piece.position
        end
      end
    end
    nil
  end

  def move(start_pos, end_pos)
    x, y = start_pos
    piece_to_move = @board[x][y]

    legal_moves = piece_to_move.possible_moves

    if legal_moves.nil?
      raise ArgumentError.new "No legal moves."
    end

    good_moves = piece_to_move.valid_moves(legal_moves)

    if good_moves.nil?
      raise ArgumentError.new "In check if there are no other errors......"
    end

    if good_moves.include?(end_pos)
      move!(start_pos, end_pos)
    end
  end

  def move!(start_pos, end_pos)
    x, y = start_pos
    piece_to_move = @board[x][y]
    @board[x][y] = nil
    dest_x, dest_y = end_pos
    dest_contents = @board[dest_x][dest_y]

    if dest_contents
      dest_contents.board = nil
    end

    @board[dest_x][dest_y] = piece_to_move
    piece_to_move.position = end_pos
  end

  def dup
    dup_board = Board.new

    @board.each_with_index do |row, row_idx |
      row.each_with_index do |piece, col|
        next if piece.nil?
        dup_piece = (piece.class).new(piece.color, piece.position, dup_board)
        dup_board.board[row_idx][col] = dup_piece
      end
    end

    dup_board
  end

  def checkmate?(color)
    good_moves = []

    @board.each_with_index do |row, row_idx |
      row.each_with_index do |piece, col|
        next if piece.nil? || piece.color != color
        legal_moves = piece.possible_moves
        good_moves += piece.valid_moves(legal_moves)
      end
    end

    return true if good_moves.empty?
    false
  end
end


class Player


end

class HumanPlayer < Player


end

class Game

  #contains two players
  #makes sure valid input sent to Pieces move methods
  #switch players, and make moves accordingly


end

b = Board.new(true)
queen = Queen.new(:w, [0,0], b)
king = Knight.new(:b, [7,7], b)
bishop1 = Bishop.new(:b, [6,7], b)
bishop2 = Bishop.new(:b, [7,6], b)
bishop3 = Bishop.new(:b, [6,6], b)

b.board[0][0] = queen
b.board[7][7] = king
b.board[6][7] = bishop1
b.board[6][6] = bishop3
b.board[7][6] = bishop2

# dup = b.dup

# queen = Queen.new(:w, [0,0], b)
# king = King.new(:b, [7,7], b)
#
# b.board[0][0] = queen
# b.board[7][7] = king
#
# puts king.move_into_check?([7,6]) == false
# puts king.move_into_check?([7,7]) == true
#
p king.valid_moves(king.possible_moves)

b.move([7,7], [6,5])

b.print_board

# p bishop2.valid_moves(bishop2.possible_moves)
p b.checkmate?(:b)

#p "I moved into check #{king.move_into_check?([7,7])}"

#p "I didn't move into check #{king.move_into_check?([7,5])}"

#b.print_board


# queen = Queen.new(:w, [0,1], b)
# pawn = Pawn.new(:w, [4,3], b)
# pawn2 = Pawn.new(:w, [0,0], b) # up
# pawn3 = Pawn.new(:w, [0,7], b) # down
# pawn4 = Pawn.new(:w, [3,1], b) #right
# pawn5 = Pawn.new(:w, [1,2], b) # diagonal
#
# b.board[0][1] = queen
# b.board[4][3] = pawn
# b.board[0][0] = pawn2
# b.board[0][7] = pawn3
# b.board[3][1] = pawn4
# b.board[1][2] = pawn5
#
# b.print_board
#
# p queen.possible_moves.sort

# p rook.board.board[4][4]