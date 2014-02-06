# encoding: utf-8
class Piece
  attr_accessor :position, :board, :color

  def initialize color, position, board = nil
    @color = color
    @position = position
    @board = board
  end

  def possible_moves
  end

  def valid_moves(move_arr)

    valid_moves = []

    move_arr.each do |end_pos|

      if !move_into_check?(end_pos)
        valid_moves << end_pos
      end

    end
    valid_moves
  end

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


  def vertical_in_way?(start_position, end_position)
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

  def move_into_check?(pos)
    dup_board = @board.dup
    dup_piece_loc = @position

    dup_board.board[pos[0]][pos[1]] = dup_board.board[@position[0]][@position[1]]
    dup_board.board[@position[0]][@position[1]].position = [pos[0],pos[1]]
    dup_board.board[@position[0]][@position[1]] = nil

    dup_board.in_check?(@color)
  end

end


class Pawn < Piece
  attr_accessor :first_move

  def initialize(color, pos, board=nil)
    super(color,pos,board)
    @move_units = [
      [1,1],
      [-1,1],
      [0,1]
    ]
    @first_move = true
  end

  def possible_moves
    valid_moves = []
    direction = self.direction
    x, y = self.position

    @move_units << [0,2] if @first_move

    @move_units.each do |(dx, dy)|
      new_position = [x + (direction * dx), y + (direction * dy)]
      if new_position[0].between?(0,7) && new_position[1].between?(0,7)
        valid_moves << new_position unless piece_in_way?(self.position, new_position)
      end
    end

    @move_units.pop if @first_move

    valid_moves
  end

  def piece_in_way?(start_pos, end_pos)
    start_x, start_y = start_pos
    end_x, end_y = end_pos

    if end_y == start_y || start_x == end_x
      return !@board.board[end_x][end_y].nil?
    else # moving diagonally
      dest_contents = @board.board[end_x][end_y]
      return true if dest_contents.nil?
      return false if dest_contents.color != self.color
    end
  end

  def direction
    direction = 0
    if @color == :b
      direction = -1
    else
      direction = 1
    end
  end

  def render
    if @color == :w
      "\u2659"
    else
      "\u265f"
    end
  end
end