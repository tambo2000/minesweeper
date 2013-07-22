class MineSweeper
  attr_accessor :board
  def initialize
    new_board = Board.new
    new_board.generate
    @board = new_board
  end

  def flag(position)
    x, y = position
    @board.board[x][y].flagged = true
    @board.board[x][y].display_value = "F "
  end

  def unflag(position)
    x, y = position
    @board.board[x][y].flagged = false
    @board.board[x][y].display_value = "* "
  end

  def reveal(position)
    x, y = position
    if @board.board[x][y].bombed
      return true
    elsif !@board.board[x][y].revealed
      bomb_free_neighbors, number_of_bombs = check_neighbors(x, y)
      @board.board[x][y].revealed = true

      if number_of_bombs == 0
        @board.board[x][y].display_value = "_ "
      else
        @board.board[x][y].display_value = number_of_bombs.to_s + " "
      end
      if number_of_bombs == 0
        bomb_free_neighbors.each do |tile|
          reveal(tile)
        end
      end
    end
    false
  end

  def play
    has_lost = false
    until has_won?
      @board.display
      p "Pick a tile to reveal:"
      input = gets.chomp.split(" ")
      input[0] = input[0].to_i
      input[1] = input[1].to_i
      if input[2] == "f"
        flag([input[0], input[1]])
      elsif input[2] == "u"
        unflag([input[0], input[1]])
      else
        has_lost = reveal([input[0],input[1]])
      end
      if has_lost
        p "You lose!"
        break
      end

    end
    p "You win!" unless has_lost
  end

  def has_won?
    @board.board.each do |line|
      line.each do |tile|
        if tile.display_value == "* "
          return false
        end
      end
    end
    true
  end

  def check_neighbors(x, y)
    bomb_free_neighbors = []
    number_of_bombs = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        if  (x + i >= 0) && (x + i < @board.board.size) && (y + j >= 0) && (y + j < @board.board.size)
          if !@board.board[x + i][y + j].bombed
            bomb_free_neighbors << [x + i, y + j]
          else
            number_of_bombs += 1
          end
        end
      end
    end
    [bomb_free_neighbors, number_of_bombs]
  end

end

class Tile
  attr_accessor :bombed, :revealed, :flagged, :display_value
  def initialize(bombed = false, revealed = false, flagged = false, display_value = "* ")
    @bombed, @revealed, @flagged, @display_value = bombed, revealed, flagged, display_value
  end

  def dup

  end

end

class Board
  attr_accessor :board

  def initialize(size = 9, number_of_bombs = 10)
    # @board = Array.new(size, Array.new(size, nil))
    @board = []
    (0..size-1).each do |row|
      @board[row] = []
      (0..size-1).each do |column|
       @board[row][column] = Tile.new
      end
    end
    @size, @number_of_bombs = size, number_of_bombs
  end

  def generate
    bombs = []
    @board.map! do |line|
      line.map! do |tile|
        tile = Tile.new
      end
    end
    until bombs.count == @number_of_bombs
      potential_bomb = [rand(@size),rand(@size)]
      if !bombs.include?(potential_bomb)
        bombs << potential_bomb
      end
    end
    bombs.each do |bomb|
      @board[bomb.first][bomb.last].bombed = true
    end
  end

  def display
    @board.each do |line|
      line.each do |tile|

        print tile.display_value

        # if tile.bombed == false
#           print "* "
#         else
#           print "B "
#         end

      end
      puts
    end
  end
end


game = MineSweeper.new

game.play
