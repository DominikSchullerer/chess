require_relative "./string"

class Board
  def initialize
    create_board
  end

  def create_board
    @squares = []
    8.times { @squares << [] }
    @squares.each do |rank|
      8.times { rank << nil }
    end
  end

  def parse_FEN_string(fen_string)
    fen_array = fen_string.split(/\s|\//)
    8.times.each do |rank|
      file = 0
      fen_array[7 - rank].chars do |char|
        case char
        when /^[KQRBNPkqrbnp]$/
          @squares[rank][file] = char
          file += 1
        when /^\d$/
          char.to_i.times do
            @squares[rank][file] = nil
            file += 1
          end
        end
      end
    end
  end

  def draw_board
    7.downto(0).each do |rank|
      row_string = ""
      8.times.each do |file|
        row_string += square_string(rank, file)
      end
      puts row_string
    end
  end

  def square_string(rank, file)
    square_string = case @squares[rank][file]
    when nil
      "   "
    when "K"
      " \u2654 "
    when "Q"
      " \u2655 "
    when "R"
      " \u2656 "
    when "B"
      " \u2657 "
    when "N"
      " \u2658 "
    when "P"
      " \u2659 "
    when "k"
      " \u265A "
    when "q"
      " \u265B "
    when "r"
      " \u265C "
    when "b"
      " \u265D "
    when "n"
      " \u265E "
    when "p"
      " \u265F "
    end

    if (rank + file) % 2 == 0
      square_string.bg_black
    else
      square_string.bg_white
    end
  end
end

board = Board.new
board.draw_board
puts ""
board.parse_FEN_string("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
board.draw_board
