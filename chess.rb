# encoding: utf-8
require_relative 'piece'
require_relative 'slidingpiece'
require_relative 'steppingpiece'
require 'colorize'

class Board
  attr_accessor :board, :turn_count

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

    # HOW DO WE ROTATE THIS 90 DEGREES???
    # we have assumed x,y coordinates; this prints as row-column (i.e. y-x)

    @board.each_with_index do |row, row_idx|
      print (row_idx + 1).to_s + " "
      row.each_with_index do |piece, col_idx|
        # if these coordinates match the cursor coordinates, render cursour insteadg
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
    puts "  | a | b | c | d | e | f | g | h "
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
      raise MoveError.new "No legal moves."
    end

    good_moves = piece_to_move.valid_moves(legal_moves)

    if good_moves.nil?
      raise MoveError.new "In check if there are no other errors......"
    end
    p good_moves
    p end_pos
    if good_moves.include?(end_pos)
      move!(start_pos, end_pos)
    else
      return false
    end
    true
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

    if piece_to_move.is_a?(Pawn)
      piece_to_move.first_move = false
    end
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

  def initialize board, color
  @color = color
  @board = board
  end

  def play_turn
    puts "It is #{@color}'s turn."
    puts "From where are you moving?"
    start_pos = parse(gets.chomp)
    play_turn if @board.board[start_pos[0]][start_pos[1]].nil?
    if @board.board[start_pos[0]][start_pos[1]].color == @color
      puts "To where are you moving?"
      end_pos = gets.chomp
      #raise errors or do something (parse)
      end_pos = parse(end_pos)
      if @board.move(start_pos, end_pos) == false
        play_turn
      end
    else
      play_turn
    end
  end

  def parse(user_input)

    letter_hash = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7
    }

    coordinates = user_input.split(',')
    # puts (coordinates[0].to_i-1)
    # puts letter_hash[coordinates[1]]
    [(coordinates[0].to_i-1), letter_hash[coordinates[1]]]
  end
end

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @white = HumanPlayer.new(@board, :w)
    @black = HumanPlayer.new(@board, :b)
  end

  def play
    until lose?(:w) || lose?(:b)
      @board.print_board
      @white.play_turn
      break if lose?(:b)
      @board.print_board
      @black.play_turn
    end
    puts "someone won"
  end

  def lose?(color)
    @board.checkmate?(color)
  end
end

# b = Board.new(true)
b = Board.new
b.print_board

# b.move([0,1], [0,3])

pawn = b.board[0][1]
# p pawn.possible_moves
# p pawn.piece_in_way?([0,1], [0,3])

puts
b.print_board

# sleep 1

# queen = Queen.new(:w, [0,1], b)
# king = Knight.new(:b, [7,4], b)
# bishop1 = Bishop.new(:b, [6,7], b)
# bishop2 = Bishop.new(:b, [7,6], b)
# bishop3 = Bishop.new(:b, [3,5], b)

# queen = Pawn.new(:w, [0,1], b)
# king = Pawn.new(:b, [7,4], b)
# bishop1 = Pawn.new(:b, [6,7], b)
# bishop2 = Pawn.new(:b, [7,6], b)
# bishop3 = Pawn.new(:b, [3,5], b)
#
#
# b.board[2][4] = queen
# b.board[7][4] = king
# b.board[6][7] = bishop1
# b.board[7][6] = bishop2
# b.board[3][5] = bishop3
#
# puts
# b.print_board
#
# b.move([3,5], [2,4])
#
# puts
# b.print_board

=begin
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

# p rook.def board.board
=end