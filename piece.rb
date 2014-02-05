# require_relative 'chess'

class Piece
  ##Process a move from game, return errors if move not possible, otherwise moves to positions(or some other class does moving, it just confirms validity and changes it's current position)

  attr_accessor :position, :board, :color

  def initialize color, position, board = nil
    @color = color
    @position = position
    @board = board
  end

  def move

  end

  def possible_moves
  end

  # assume that all pieces need to take into account other pieces in the way (in its path)
  # calls possible moves and takes out moves that would run into someone

  #passes in [x,y] style start position and end position
  def piece_in_way?(start_position, end_position)
    if start_position[1] == end_position[1]
      horizontal_in_way?(start_position,end_position)
    elsif start_position[0] == end_position[0]
      vertical_in_way?(start_position,end_position)
    else
      diagonal_in_way?(start_position, end_position)
    end
  end

  def horizontal_in_way?(start_position, end_position)
    # rightmost = [start_position[0], end_position[0]].max
    # leftmost = [start_position[0], end_position[0]].min
    #
    # (leftmost..rightmost).each do |x|
    #
    #   unless @board.board[x][start_position[1]].nil?
    #     return false
    #   end
    # end
    # true
    opponent_color = self.color == :b ? :w : :b

    x_vector = end_position[0] - start_position[0]

    abs_x_vector = x_vector.abs

    unit_vector = [x_vector/abs_x_vector, 0]

    cell_to_check = start_position
    until cell_to_check == end_position
      x = cell_to_check[0] + unit_vector[0]
      y = cell_to_check[1] + unit_vector[1]
      cell_to_check = [x, y]
      unless @board.board[x][y].nil?
        unless (cell_to_check == end_position && @board.board[x][y].color == opponent_color)
          return true
        end
      end
    end
    false

  end

  # def vertical_in_way?(start_position, end_position)
  #   upper = [start_position[1], end_position[1]].min
  #   lower = [start_position[1], end_position[1]].max
  #   (upper..lower).each do |y|
  #   # (start_position[1]..end_position[1]).each do |y|
  #     # p [start_position[0], y]
  #     puts "#{[start_position[0], y]} contains #{(@board.board[start_position[0]][y]).class}"
  #     unless (@board.board[start_position[0]][y]).nil?
  #       return true
  #     end
  #   end
  #
  #   false
  # end

  def vertical_in_way?(start_position, end_position)
    # gather all verticals
    # if any are between (its y is between start and end's y's)
    # then something's in the way
    # occupied_ys = []
    #
    # (0..7).each do |y_position|
    #   x = start_position[0]
    #   contents = @board.board[x][y_position]
    #   occupied_ys << y_position unless contents.nil?
    # end
    #
    # occupied_ys.each do |y|
    #   if y.between?(start_position[1], end_position[1])
    #     return false
    #   end
    # end
    #
    # true

    opponent_color = self.color == :b ? :w : :b

    y_vector = end_position[1] - start_position[1]

    abs_y_vector = y_vector.abs

    unit_vector = [0, y_vector/abs_y_vector]

    cell_to_check = start_position
    until cell_to_check == end_position
      x = cell_to_check[0] + unit_vector[0]
      y = cell_to_check[1] + unit_vector[1]
      cell_to_check = [x, y]
      unless @board.board[x][y].nil?
        unless (cell_to_check == end_position && @board.board[x][y].color == opponent_color)
          return true
        end
      end
    end
    false

  end

  def diagonal_in_way?(start_position, end_position)

    opponent_color = self.color == :b ? :w : :b

    x_vector = end_position[0] - start_position[0]
    y_vector = end_position[1] - start_position[1]

    abs_x_vector, abs_y_vector = x_vector.abs, y_vector.abs

    unit_vector = [x_vector/abs_x_vector, y_vector/abs_y_vector]

    cell_to_check = start_position
    until cell_to_check == end_position
      x = cell_to_check[0] + unit_vector[0]
      y = cell_to_check[1] + unit_vector[1]
      cell_to_check = [x, y]
      unless @board.board[x][y].nil?
        unless (cell_to_check == end_position && @board.board[x][y].color == opponent_color)
          return true
        end
      end
    end
    false
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
        valid_moves << new_position #if piece_in_way?(self.position, new_position) # add to other pieces
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

