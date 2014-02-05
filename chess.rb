require_relative 'piece'
require_relative 'slidingpiece'
require_relative 'steppingpiece'


class Board
  attr_accessor :board

  def initialize
    @board = create_empty_board
    # populate_board
  end

  def create_empty_board
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    # populate board with pieces (3 ways - pawn rows x 2, royals (white), royals (black))
    # pawns
    (0..7).each do |x|
      @board[x][1] = Pawn.new(:w, [x, 1], self)
      @board[x][6] = Pawn.new(:b, [x, 6], self)
    end

    # everyone but king and queen
    (0..7).each do |x|
      if x == 0 || x == 7
        # place a rook at row 0, row 7
        @board[x][0] = Rook.new(:w, [x, 0], self)
        @board[x][7] = Rook.new(:b, [x, 7], self)
      elsif x == 1 || x ==6
        # place a knight
        @board[x][0] = Knight.new(:w, [x, 0], self)
        @board[x][7] = Knight.new(:b, [x, 7], self)
      elsif x == 2 || x == 5
        #place a bishop
        @board[x][0] = Bishop.new(:w, [x, 0], self)
        @board[x][7] = Bishop.new(:b, [x, 7], self)
      elsif x == 3
        #King
        @board[x][0] = King.new(:w, [x, 0], self)
        @board[x][7] = King.new(:b, [x, 7], self)
      elsif x == 4
        #Queen
        @board[x][0] = Queen.new(:w, [x, 0], self)
        @board[x][7] = Queen.new(:b, [x, 7], self)
      end

    end

  end

  def piece_taken
    #sets taken pieces to nil
  end

  def print_board
    #simple (really stinks)
    @board.each do |row|
      row.each do |piece|
        puts piece.class
      end
      puts
    end

  end

  # incorporate other players into piece class # move
  #
#  # def []()
  #   @board[row][column]
  # end

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

b = Board.new
queen = Queen.new(:w, [0,1], b)
pawn = Pawn.new(:w, [4,3], b)
pawn2 = Pawn.new(:w, [0,0], b) # up
pawn3 = Pawn.new(:w, [0,7], b) # down
pawn4 = Pawn.new(:w, [3,1], b) #right
pawn5 = Pawn.new(:w, [1,2], b) # diagonal

b.board[0][1] = queen
b.board[4][3] = pawn
b.board[0][0] = pawn2
b.board[0][7] = pawn3
b.board[3][1] = pawn4
b.board[1][2] = pawn5

b.print_board

p queen.possible_moves.sort

# p rook.board.board[4][4]